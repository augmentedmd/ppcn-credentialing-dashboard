import {
  clearSessionCookie,
  error,
  json,
  parseCookies,
  sessionCookie,
  toPublicUser,
  hashPassword,
  verifyPassword,
  validatePassword,
} from "./auth";
import {
  BOARD_MEMBER_IDS,
  applyDefToMatchingPackets,
  listChecklistDefs,
  loadSpecialtiesMap,
  makeItemKey,
  mapChecklistDef,
  newId,
  resolveChecklistForPacket,
} from "./checklist";
import type {
  ChecklistDefRow,
  ChecklistScope,
  Env,
  ItemStatus,
  PacketCommentRow,
  PacketEventRow,
  PacketEventType,
  PacketItemRow,
  PacketRow,
  PacketStatus,
  ProviderType,
  PublicUser,
  SpecialtyRow,
  UserRow,
  VoteChoice,
  VoteRow,
} from "./types";

type Authed = { user: PublicUser; row: UserRow };

const ITEM_STATUS_LABELS: Record<ItemStatus, string> = {
  pending: "Pending",
  complete: "Done",
  na: "N/A",
};

const VOTE_LABELS: Record<VoteChoice, string> = {
  yes: "Yes",
  no: "No",
  pause_for_query: "Pause for Query",
};

async function logPacketEvent(
  env: Env,
  packetId: string,
  actor: { id?: string | null; name: string } | null,
  eventType: PacketEventType,
  summary: string,
  detail = ""
) {
  await env.DB.prepare(
    `INSERT INTO packet_events
      (id, packet_id, actor_user_id, actor_name, event_type, summary, detail)
     VALUES (?, ?, ?, ?, ?, ?, ?)`
  )
    .bind(
      newId("evt"),
      packetId,
      actor?.id || null,
      actor?.name || "System",
      eventType,
      summary,
      detail
    )
    .run();
}

function mapEvent(row: PacketEventRow) {
  return {
    id: row.id,
    packetId: row.packet_id,
    actorUserId: row.actor_user_id,
    actorName: row.actor_name,
    eventType: row.event_type,
    summary: row.summary,
    detail: row.detail,
    createdAt: row.created_at,
  };
}

async function loadPacketActivity(env: Env, packetId: string) {
  const events = (
    await env.DB.prepare(
      `SELECT * FROM packet_events WHERE packet_id = ? ORDER BY created_at DESC, rowid DESC`
    )
      .bind(packetId)
      .all<PacketEventRow>()
  ).results;
  return events.map(mapEvent);
}

async function getUserBySession(env: Env, request: Request): Promise<Authed | null> {
  const cookies = parseCookies(request.headers.get("Cookie"));
  const token = cookies.session;
  if (!token) return null;

  const row = await env.DB.prepare(
    `SELECT u.* FROM sessions s
     JOIN users u ON u.id = s.user_id
     WHERE s.token = ? AND s.expires_at > datetime('now') AND u.active = 1`
  )
    .bind(token)
    .first<UserRow>();

  if (!row) return null;
  return { user: toPublicUser(row), row };
}

async function requireAuth(env: Env, request: Request): Promise<Authed | Response> {
  const auth = await getUserBySession(env, request);
  if (!auth) return error("Unauthorized", 401);
  return auth;
}

async function requireAdmin(env: Env, request: Request): Promise<Authed | Response> {
  const auth = await requireAuth(env, request);
  if (auth instanceof Response) return auth;
  if (auth.user.role !== "admin") return error("Admin access required", 403);
  return auth;
}

async function requireAdminOrBoard(env: Env, request: Request): Promise<Authed | Response> {
  const auth = await requireAuth(env, request);
  if (auth instanceof Response) return auth;
  if (auth.user.role !== "admin" && auth.user.role !== "board") {
    return error("Admin or governing board access required", 403);
  }
  return auth;
}

/** Normalize DB role quirks (watcher may still be stored as board). */
function effectiveUserRole(row: { id: string; username: string; role: string }): string {
  if (row.id === "usr_watcher" || row.username.toLowerCase() === "watcher") {
    return "watcher";
  }
  return row.role;
}

function mapItem(row: PacketItemRow) {
  return {
    id: row.id,
    key: row.item_key,
    label: row.label,
    sortOrder: row.sort_order,
    status: row.status,
    notes: row.notes,
    updatedAt: row.updated_at,
    sourceScope: row.source_scope || "global",
    sourceDefId: row.source_def_id || null,
  };
}

function mapVote(row: VoteRow) {
  return {
    id: row.id,
    voterUserId: row.voter_user_id,
    voterName: row.voter_name,
    vote: row.vote,
    concern: row.concern,
    queryResolution: row.query_resolution,
    votedAt: row.voted_at,
    resolutionAt: row.resolution_at,
  };
}

function mapPacket(
  row: PacketRow,
  specialties: Record<string, string>,
  items?: PacketItemRow[],
  votes?: VoteRow[]
) {
  let privilegeBlocks: string[] = [];
  try {
    privilegeBlocks = JSON.parse(row.privilege_blocks || "[]");
  } catch {
    privilegeBlocks = [];
  }

  const mappedItems = items ? items.map(mapItem) : undefined;
  const completed =
    mappedItems?.filter((i) => i.status === "complete" || i.status === "na").length ?? 0;
  const total = mappedItems?.length ?? 0;
  const pendingRequired =
    mappedItems?.filter((i) => i.status === "pending").length ?? 0;

  return {
    id: row.id,
    providerName: row.provider_name,
    providerType: row.provider_type,
    specialty: row.specialty,
    specialtyLabel: specialties[row.specialty] || row.specialty,
    credentialingType: row.credentialing_type,
    privilegeBlocks,
    status: row.status,
    notes: row.notes,
    createdBy: row.created_by,
    createdAt: row.created_at,
    updatedAt: row.updated_at,
    readyAt: row.ready_at,
    closedAt: row.closed_at,
    progress: mappedItems
      ? { completed, total, pendingRequired, allDone: pendingRequired === 0 && total > 0 }
      : undefined,
    items: mappedItems,
    votes: votes ? votes.map(mapVote) : undefined,
  };
}

async function loadPacketDetail(env: Env, id: string, specialties?: Record<string, string>) {
  try {
    await revertReadyPacketsWithOpenItems(env, id);
  } catch (err) {
    console.error("revertReadyPacketsWithOpenItems failed", err);
  }

  const packet = await env.DB.prepare(`SELECT * FROM packets WHERE id = ?`)
    .bind(id)
    .first<PacketRow>();
  if (!packet) return null;

  const items = (
    await env.DB.prepare(
      `SELECT * FROM packet_items WHERE packet_id = ? ORDER BY sort_order ASC`
    )
      .bind(id)
      .all<PacketItemRow>()
  ).results;

  const votes = (
    await env.DB.prepare(
      `SELECT v.* FROM votes v
       LEFT JOIN users u ON u.id = v.voter_user_id
       WHERE v.packet_id = ?
         AND v.voter_user_id != 'usr_watcher'
         AND lower(v.voter_name) != 'watcher'
         AND coalesce(u.role, 'board') != 'watcher'
         AND coalesce(lower(u.username), '') != 'watcher'
       ORDER BY v.voter_name ASC`
    )
      .bind(id)
      .all<VoteRow>()
  ).results;

  const specs = specialties || await loadSpecialtiesMap(env);
  return mapPacket(packet, specs, items, votes);
}

async function createVoteSlots(env: Env, packetId: string) {
  const board = (
    await env.DB.prepare(
      `SELECT id, display_name FROM users
       WHERE role = 'board' AND active = 1
         AND id != 'usr_watcher' AND username != 'watcher'
         AND lower(username) != 'watcher'
       ORDER BY display_name`
    ).all<{ id: string; display_name: string }>()
  ).results;

  const stmts = board.map((b) =>
    env.DB.prepare(
      `INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution)
       VALUES (?, ?, ?, ?, NULL, '', '')`
    ).bind(newId("vote"), packetId, b.id, b.display_name)
  );

  if (stmts.length) await env.DB.batch(stmts);

  // Watchers must never appear in the board vote grid.
  await env.DB.prepare(
    `DELETE FROM votes
     WHERE packet_id = ?
       AND (voter_user_id = 'usr_watcher' OR lower(voter_name) = 'watcher'
            OR voter_user_id IN (SELECT id FROM users WHERE role = 'watcher'
                                 OR id = 'usr_watcher' OR lower(username) = 'watcher'))`
  )
    .bind(packetId)
    .run();
}

async function packetHasOpenItems(env: Env, packetId: string): Promise<boolean> {
  const row = await env.DB.prepare(
    `SELECT COUNT(*) AS n FROM packet_items WHERE packet_id = ? AND status = 'pending'`
  )
    .bind(packetId)
    .first<{ n: number }>();
  return (row?.n || 0) > 0;
}

async function packetItemCounts(
  env: Env,
  packetId: string
): Promise<{ total: number; pending: number }> {
  const row = await env.DB.prepare(
    `SELECT COUNT(*) AS total,
            SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) AS pending
     FROM packet_items WHERE packet_id = ?`
  )
    .bind(packetId)
    .first<{ total: number; pending: number | null }>();
  return { total: row?.total || 0, pending: row?.pending || 0 };
}

/** When every checklist item is Complete or N/A, move In Progress → Ready for Review. */
async function autoMarkReadyIfComplete(
  env: Env,
  packetId: string,
  actor: { id: string; name: string } | null
): Promise<boolean> {
  const packet = await env.DB.prepare(`SELECT * FROM packets WHERE id = ?`)
    .bind(packetId)
    .first<PacketRow>();
  if (!packet || packet.status !== "in_progress") return false;

  const { total, pending } = await packetItemCounts(env, packetId);
  if (total === 0 || pending > 0) return false;

  await env.DB.prepare(
    `UPDATE packets SET status = 'ready_for_review', ready_at = datetime('now'),
       updated_at = datetime('now'), closed_at = NULL
     WHERE id = ? AND status = 'in_progress'`
  )
    .bind(packetId)
    .run();

  await logPacketEvent(
    env,
    packetId,
    actor,
    "marked_ready",
    "Marked packet Ready for Review",
    "All checklist components Complete or N/A"
  );
  return true;
}

/** Promote any In Progress packets that are already 100% complete. */
async function promoteCompletePackets(env: Env): Promise<number> {
  const rows = (
    await env.DB.prepare(
      `SELECT p.id
       FROM packets p
       WHERE p.status = 'in_progress'
         AND EXISTS (SELECT 1 FROM packet_items i WHERE i.packet_id = p.id)
         AND NOT EXISTS (
           SELECT 1 FROM packet_items i2
           WHERE i2.packet_id = p.id AND i2.status = 'pending'
         )`
    ).all<{ id: string }>()
  ).results;

  let n = 0;
  for (const row of rows) {
    if (await autoMarkReadyIfComplete(env, row.id, null)) n += 1;
  }
  return n;
}

/** Ready-for-review is invalid while any checklist item is still Pending. */
async function revertReadyPacketsWithOpenItems(
  env: Env,
  packetId?: string
): Promise<string[]> {
  let q = `
    SELECT DISTINCT p.id
    FROM packets p
    INNER JOIN packet_items i ON i.packet_id = p.id
    WHERE p.status = 'ready_for_review' AND i.status = 'pending'`;
  const binds: string[] = [];
  if (packetId) {
    q += ` AND p.id = ?`;
    binds.push(packetId);
  }

  const stmt = env.DB.prepare(q);
  const rows = (
    binds.length
      ? await stmt.bind(...binds).all<{ id: string }>()
      : await stmt.all<{ id: string }>()
  ).results;

  for (const row of rows) {
    await env.DB.prepare(
      `UPDATE packets
       SET status = 'in_progress', updated_at = datetime('now'), ready_at = NULL
       WHERE id = ? AND status = 'ready_for_review'`
    )
      .bind(row.id)
      .run();

    await logPacketEvent(
      env,
      row.id,
      null,
      "status_changed",
      "Packet returned to In Progress",
      "Open checklist items remain; Ready for Review requires every item Complete or N/A"
    );
  }

  return rows.map((r) => r.id);
}

async function recomputePacketStatus(env: Env, packetId: string): Promise<PacketStatus> {
  const packet = await env.DB.prepare(`SELECT * FROM packets WHERE id = ?`)
    .bind(packetId)
    .first<PacketRow>();
  if (!packet) throw new Error("Packet not found");

  if (packet.status === "in_progress") return "in_progress";

  const votes = (
    await env.DB.prepare(`SELECT * FROM votes WHERE packet_id = ?`)
      .bind(packetId)
      .all<VoteRow>()
  ).results;

  const prev = packet.status;
  const cast = votes.filter((v) => v.vote);
  const hasPause = cast.some((v) => v.vote === "pause_for_query");
  const hasOpenItems = await packetHasOpenItems(env, packetId);
  let next: PacketStatus;

  if (hasPause) {
    await env.DB.prepare(
      `UPDATE packets SET status = 'query_pending', updated_at = datetime('now'), closed_at = NULL WHERE id = ?`
    )
      .bind(packetId)
      .run();
    next = "query_pending";
  } else if (hasOpenItems) {
    // Charts with any open checklist items cannot be Ready for Review.
    await env.DB.prepare(
      `UPDATE packets SET status = 'in_progress', updated_at = datetime('now'),
         ready_at = NULL, closed_at = NULL WHERE id = ?`
    )
      .bind(packetId)
      .run();
    next = "in_progress";
  } else if (cast.length < votes.length || votes.length === 0) {
    await env.DB.prepare(
      `UPDATE packets SET status = 'ready_for_review', updated_at = datetime('now'), closed_at = NULL WHERE id = ?`
    )
      .bind(packetId)
      .run();
    next = "ready_for_review";
  } else if (cast.some((v) => v.vote === "no")) {
    await env.DB.prepare(
      `UPDATE packets SET status = 'denied', updated_at = datetime('now'), closed_at = datetime('now') WHERE id = ?`
    )
      .bind(packetId)
      .run();
    next = "denied";
  } else {
    await env.DB.prepare(
      `UPDATE packets SET status = 'approved', updated_at = datetime('now'), closed_at = datetime('now') WHERE id = ?`
    )
      .bind(packetId)
      .run();
    next = "approved";
  }

  if (next !== prev) {
    const summaries: Record<PacketStatus, string> = {
      in_progress: "Packet returned to in progress",
      ready_for_review: "Packet returned to Ready for Review",
      query_pending: "Packet held for query",
      approved: "Packet approved",
      denied: "Packet denied",
    };
    const details: Partial<Record<PacketStatus, string>> = {
      query_pending: "At least one governing board member paused for query",
      approved: "All governing board votes were Yes",
      denied: "At least one governing board vote was No",
    };
    await logPacketEvent(env, packetId, null, "status_changed", summaries[next], details[next] || "");
  }

  return next;
}

async function handleApi(request: Request, env: Env): Promise<Response> {
  const url = new URL(request.url);
  const path = url.pathname;
  const method = request.method.toUpperCase();

  if (method === "GET" && path === "/api/health") {
    return json({ ok: true, app: env.APP_NAME || "PPCN Credentialing Dashboard" });
  }

  if (method === "GET" && path === "/api/meta") {
    const specialties = await loadSpecialtiesMap(env);
    return json({
      specialties,
      boardMemberIds: BOARD_MEMBER_IDS,
      statuses: [
        "in_progress",
        "ready_for_review",
        "query_pending",
        "approved",
        "denied",
      ],
    });
  }

  // ---- User management (admin only) ----
  if (method === "GET" && path === "/api/users") {
    const auth = await requireAdmin(env, request);
    if (auth instanceof Response) return auth;

    const users = (
      await env.DB.prepare(
        `SELECT id, username, display_name, email, role, active, must_change_password, created_at
         FROM users WHERE active = 1 ORDER BY display_name ASC`
      ).all<UserRow>()
    ).results;

    return json({
      users: users.map((u) => ({
        id: u.id,
        username: u.username,
        displayName: u.display_name,
        email: u.email,
        role: effectiveUserRole(u),
        active: !!u.active,
        mustChangePassword: !!u.must_change_password,
        createdAt: u.created_at,
      })),
    });
  }

  if (method === "POST" && path === "/api/users") {
    const auth = await requireAdmin(env, request);
    if (auth instanceof Response) return auth;

    // Standard first-login password for all new accounts (must change on sign-in).
    const TEMP_PASSWORD = "ChangeMeBoard1!";

    const body = (await request.json().catch(() => null)) as {
      username?: string;
      displayName?: string;
      firstName?: string;
      lastName?: string;
      email?: string;
      role?: string;
    } | null;

    if (!body) return error("Request body is required");

    const username = body.username?.trim();
    if (!username) return error("Username is required");
    if (username.length < 3) return error("Username must be at least 3 characters");

    const firstName = body.firstName?.trim() || "";
    const lastName = body.lastName?.trim() || "";
    const displayName =
      body.displayName?.trim() ||
      [firstName, lastName].filter(Boolean).join(" ").trim();
    if (!displayName) return error("First name and last name are required");
    if (!firstName || !lastName) {
      return error("First name and last name are required");
    }

    const email = body.email?.trim() || "";
    if (!email) return error("Email address is required");

    const role = body.role;
    if (!role || !["admin", "board", "watcher"].includes(role)) {
      return error("Role must be admin, board, or watcher");
    }

    const existing = await env.DB.prepare(
      `SELECT id FROM users WHERE username = ? COLLATE NOCASE`
    )
      .bind(username)
      .first();
    if (existing) return error("Username already exists", 409);

    const { hash, salt } = await hashPassword(TEMP_PASSWORD);
    const userId = newId("usr");

    await env.DB.prepare(
      `INSERT INTO users (id, username, display_name, email, role, password_hash, password_salt, must_change_password, active)
       VALUES (?, ?, ?, ?, ?, ?, ?, 1, 1)`
    )
      .bind(userId, username, displayName, email, role, hash, salt)
      .run();

    const user = await env.DB.prepare(`SELECT * FROM users WHERE id = ?`)
      .bind(userId)
      .first<UserRow>();
    if (!user) return error("Failed to create user", 500);

    return json(
      {
        user: {
          id: user.id,
          username: user.username,
          displayName: user.display_name,
          email: user.email,
          role: user.role,
          active: !!user.active,
          mustChangePassword: !!user.must_change_password,
        },
        temporaryPassword: TEMP_PASSWORD,
      },
      { status: 201 }
    );
  }

  const userMatch = path.match(/^\/api\/users\/([^/]+)$/);
  if (userMatch) {
    const userId = decodeURIComponent(userMatch[1]);

    if (method === "PATCH") {
      const auth = await requireAdmin(env, request);
      if (auth instanceof Response) return auth;

      const existing = await env.DB.prepare(`SELECT * FROM users WHERE id = ?`)
        .bind(userId)
        .first<UserRow>();
      if (!existing) return error("User not found", 404);

      const body = (await request.json().catch(() => null)) as {
        displayName?: string;
        email?: string;
        role?: string;
        active?: boolean;
      } | null;

      const nextDisplayName = body?.displayName?.trim() || existing.display_name;
      const nextEmail = body?.email?.trim() ?? existing.email;
      const nextRole = body?.role || existing.role;
      const nextActive = body?.active !== undefined ? (body.active ? 1 : 0) : existing.active;

      if (nextRole && !["admin", "board", "watcher"].includes(nextRole)) {
        return error("Role must be admin, board, or watcher");
      }

      await env.DB.prepare(
        `UPDATE users SET display_name = ?, email = ?, role = ?, active = ? WHERE id = ?`
      )
        .bind(nextDisplayName, nextEmail, nextRole, nextActive, userId)
        .run();

      const updated = await env.DB.prepare(`SELECT * FROM users WHERE id = ?`)
        .bind(userId)
        .first<UserRow>();

      return json({
        user: {
          id: updated!.id,
          username: updated!.username,
          displayName: updated!.display_name,
          email: updated!.email,
          role: updated!.role,
          active: !!updated!.active,
          mustChangePassword: !!updated!.must_change_password,
        },
      });
    }

    if (method === "DELETE") {
      const auth = await requireAdmin(env, request);
      if (auth instanceof Response) return auth;

      if (userId === auth.user.id) {
        return error("Cannot delete your own account", 400);
      }

      await env.DB.prepare(`UPDATE users SET active = 0 WHERE id = ?`)
        .bind(userId)
        .run();

      return json({ ok: true });
    }
  }

  // ---- Specialty management (admin) ----
  if (method === "GET" && path === "/api/specialties") {
    const auth = await requireAuth(env, request);
    if (auth instanceof Response) return auth;

    const providerType = url.searchParams.get("providerType") as ProviderType | null;
    let q = `SELECT * FROM specialties WHERE active = 1`;
    const binds: string[] = [];
    if (providerType) {
      q += ` AND provider_type = ?`;
      binds.push(providerType);
    }
    q += ` ORDER BY provider_type ASC, sort_order ASC`;

    const stmt = env.DB.prepare(q);
    const rows = (
      binds.length
        ? await stmt.bind(...binds).all<SpecialtyRow>()
        : await stmt.all<SpecialtyRow>()
    ).results;

    return json({
      specialties: rows.map((s) => ({
        id: s.id,
        key: s.key,
        label: s.label,
        providerType: s.provider_type,
        sortOrder: s.sort_order,
        active: !!s.active,
        createdAt: s.created_at,
      })),
    });
  }

  if (method === "POST" && path === "/api/specialties") {
    const auth = await requireAdmin(env, request);
    if (auth instanceof Response) return auth;

    const body = (await request.json().catch(() => null)) as {
      key?: string;
      label?: string;
      providerType?: ProviderType;
      sortOrder?: number;
    } | null;

    if (!body) return error("Request body is required");

    const label = body.label?.trim();
    if (!label) return error("Specialty label is required");

    const providerType = body.providerType;
    if (!providerType || !["surgeon", "pa", "anesthesia"].includes(providerType)) {
      return error("Valid provider type is required");
    }

    const key = body.key?.trim() || makeItemKey(label);

    const existing = await env.DB.prepare(
      `SELECT id FROM specialties WHERE key = ? COLLATE NOCASE`
    )
      .bind(key)
      .first();
    if (existing) return error("Specialty key already exists", 409);

    const sortOrder =
      typeof body.sortOrder === "number"
        ? body.sortOrder
        : (
            (
              await env.DB.prepare(
                `SELECT COALESCE(MAX(sort_order), 0) AS m FROM specialties WHERE provider_type = ?`
              )
                .bind(providerType)
                .first<{ m: number }>()
            )?.m || 0
          ) + 1;

    const specialtyId = newId("spec");

    await env.DB.prepare(
      `INSERT INTO specialties (id, key, label, provider_type, sort_order, active)
       VALUES (?, ?, ?, ?, ?, 1)`
    )
      .bind(specialtyId, key, label, providerType, sortOrder)
      .run();

    const specialty = await env.DB.prepare(`SELECT * FROM specialties WHERE id = ?`)
      .bind(specialtyId)
      .first<SpecialtyRow>();
    if (!specialty) return error("Failed to create specialty", 500);

    return json(
      {
        specialty: {
          id: specialty.id,
          key: specialty.key,
          label: specialty.label,
          providerType: specialty.provider_type,
          sortOrder: specialty.sort_order,
          active: !!specialty.active,
        },
      },
      { status: 201 }
    );
  }

  const specialtyMatch = path.match(/^\/api\/specialties\/([^/]+)$/);
  if (specialtyMatch) {
    const specialtyId = decodeURIComponent(specialtyMatch[1]);

    if (method === "PATCH") {
      const auth = await requireAdmin(env, request);
      if (auth instanceof Response) return auth;

      const existing = await env.DB.prepare(`SELECT * FROM specialties WHERE id = ?`)
        .bind(specialtyId)
        .first<SpecialtyRow>();
      if (!existing || !existing.active) return error("Specialty not found", 404);

      const body = (await request.json().catch(() => null)) as {
        label?: string;
        sortOrder?: number;
      } | null;

      const nextLabel = body?.label?.trim() || existing.label;
      const nextSort =
        typeof body?.sortOrder === "number" ? body.sortOrder : existing.sort_order;

      await env.DB.prepare(
        `UPDATE specialties SET label = ?, sort_order = ? WHERE id = ?`
      )
        .bind(nextLabel, nextSort, specialtyId)
        .run();

      const updated = await env.DB.prepare(`SELECT * FROM specialties WHERE id = ?`)
        .bind(specialtyId)
        .first<SpecialtyRow>();

      return json({
        specialty: {
          id: updated!.id,
          key: updated!.key,
          label: updated!.label,
          providerType: updated!.provider_type,
          sortOrder: updated!.sort_order,
          active: !!updated!.active,
        },
      });
    }

    if (method === "DELETE") {
      const auth = await requireAdmin(env, request);
      if (auth instanceof Response) return auth;

      const inUse = await env.DB.prepare(
        `SELECT COUNT(*) as count FROM packets WHERE specialty = (SELECT key FROM specialties WHERE id = ?)`
      )
        .bind(specialtyId)
        .first<{ count: number }>();

      if (inUse && inUse.count > 0) {
        return error(
          "Cannot delete specialty that is in use by existing packets",
          400
        );
      }

      await env.DB.prepare(`UPDATE specialties SET active = 0 WHERE id = ?`)
        .bind(specialtyId)
        .run();

      return json({ ok: true });
    }
  }

  // ---- Checklist templates (admin) ----
  if (method === "GET" && path === "/api/checklist-defs") {
    const auth = await requireAuth(env, request);
    if (auth instanceof Response) return auth;
    const scope = url.searchParams.get("scope") as ChecklistScope | null;
    const specialty = url.searchParams.get("specialty") || undefined;
    const packetId = url.searchParams.get("packetId") || undefined;
    const defs = await listChecklistDefs(env, {
      scope: scope || undefined,
      specialty,
      packetId,
    });
    return json({ defs });
  }

  if (method === "POST" && path === "/api/checklist-defs") {
    const auth = await requireAdmin(env, request);
    if (auth instanceof Response) return auth;

    const body = (await request.json().catch(() => null)) as {
      label?: string;
      key?: string;
      scope?: ChecklistScope;
      credentialingType?: "new" | "recred" | "both";
      specialty?: string | null;
      packetId?: string | null;
      sortOrder?: number;
      applyToExisting?: boolean;
    } | null;

    if (!body) return error("Request body is required");
    const label = body.label?.trim();
    if (!label) return error("Item label is required");
    const scope = body.scope || "global";
    if (!["global", "specialty", "packet"].includes(scope)) {
      return error("Scope must be global, specialty, or packet");
    }
    const credentialingType = body.credentialingType || "both";
    if (!["new", "recred", "both"].includes(credentialingType)) {
      return error("credentialingType must be new, recred, or both");
    }
    if (scope === "specialty") {
      if (!body.specialty) return error("Valid specialty is required for specialty-scoped items");
      const specialtyExists = await env.DB.prepare(
        `SELECT id FROM specialties WHERE key = ? AND active = 1`
      )
        .bind(body.specialty)
        .first();
      if (!specialtyExists) return error("Valid specialty is required for specialty-scoped items");
    }
    if (scope === "packet") {
      if (!body.packetId) return error("packetId is required for provider-specific items");
      const pkt = await env.DB.prepare(`SELECT id FROM packets WHERE id = ?`)
        .bind(body.packetId)
        .first();
      if (!pkt) return error("Packet not found", 404);
    }

    const itemKey = (body.key?.trim() || makeItemKey(label)).slice(0, 64);
    const defId = newId("cdef");
    const sortOrder =
      typeof body.sortOrder === "number"
        ? body.sortOrder
        : (
            await env.DB.prepare(
              `SELECT COALESCE(MAX(sort_order), 0) AS m FROM checklist_defs WHERE scope = ?`
            )
              .bind(scope)
              .first<{ m: number }>()
          )?.m || 0;

    await env.DB.prepare(
      `INSERT INTO checklist_defs
        (id, item_key, label, scope, credentialing_type, specialty, packet_id, sort_order, active)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)`
    )
      .bind(
        defId,
        itemKey,
        label,
        scope,
        credentialingType,
        scope === "specialty" ? body.specialty! : null,
        scope === "packet" ? body.packetId! : null,
        sortOrder + 1
      )
      .run();

    const def = await env.DB.prepare(`SELECT * FROM checklist_defs WHERE id = ?`)
      .bind(defId)
      .first<ChecklistDefRow>();
    if (!def) return error("Failed to create checklist item", 500);

    let applied = 0;
    if (body.applyToExisting !== false) {
      applied = await applyDefToMatchingPackets(env, def);
    }

    return json({ def: mapChecklistDef(def), appliedToPackets: applied }, { status: 201 });
  }

  const checklistDefMatch = path.match(/^\/api\/checklist-defs\/([^/]+)$/);
  if (checklistDefMatch) {
    const defId = decodeURIComponent(checklistDefMatch[1]);

    if (method === "PATCH") {
      const auth = await requireAdmin(env, request);
      if (auth instanceof Response) return auth;
      const existing = await env.DB.prepare(`SELECT * FROM checklist_defs WHERE id = ?`)
        .bind(defId)
        .first<ChecklistDefRow>();
      if (!existing || !existing.active) return error("Checklist item not found", 404);

      const body = (await request.json().catch(() => null)) as {
        label?: string;
        sortOrder?: number;
      } | null;

      const nextLabel = body?.label?.trim() || existing.label;
      const nextSort =
        typeof body?.sortOrder === "number" ? body.sortOrder : existing.sort_order;

      await env.DB.prepare(
        `UPDATE checklist_defs SET label = ?, sort_order = ? WHERE id = ?`
      )
        .bind(nextLabel, nextSort, defId)
        .run();

      if (nextLabel !== existing.label) {
        await env.DB.prepare(
          `UPDATE packet_items SET label = ? WHERE source_def_id = ?`
        )
          .bind(nextLabel, defId)
          .run();
      }

      const updated = await env.DB.prepare(`SELECT * FROM checklist_defs WHERE id = ?`)
        .bind(defId)
        .first<ChecklistDefRow>();
      return json({ def: mapChecklistDef(updated!) });
    }

    if (method === "DELETE") {
      const auth = await requireAdmin(env, request);
      if (auth instanceof Response) return auth;
      const existing = await env.DB.prepare(`SELECT * FROM checklist_defs WHERE id = ?`)
        .bind(defId)
        .first<ChecklistDefRow>();
      if (!existing) return error("Checklist item not found", 404);

      await env.DB.prepare(`UPDATE checklist_defs SET active = 0 WHERE id = ?`)
        .bind(defId)
        .run();

      const removed = await env.DB.prepare(
        `DELETE FROM packet_items WHERE source_def_id = ?`
      )
        .bind(defId)
        .run();

      return json({ ok: true, removedItems: removed.meta.changes || 0 });
    }
  }

  // ---- Auth ----
  if (method === "POST" && path === "/api/login") {
    const body = (await request.json().catch(() => null)) as {
      username?: string;
      password?: string;
    } | null;
    if (!body?.username || !body?.password) {
      return error("Username and password are required");
    }

    const row = await env.DB.prepare(
      `SELECT * FROM users WHERE username = ? COLLATE NOCASE AND active = 1`
    )
      .bind(body.username.trim())
      .first<UserRow>();

    if (!row || !(await verifyPassword(body.password, row.password_salt, row.password_hash))) {
      return error("Invalid username or password", 401);
    }

    const token = crypto.randomUUID() + crypto.randomUUID();
    const days = Number(env.SESSION_DAYS || "14") || 14;
    const secure = new URL(request.url).protocol === "https:";
    await env.DB.prepare(
      `INSERT INTO sessions (token, user_id, expires_at)
       VALUES (?, ?, datetime('now', ?))`
    )
      .bind(token, row.id, `+${days} days`)
      .run();

    return json(
      { user: toPublicUser(row) },
      { headers: { "Set-Cookie": sessionCookie(token, days, secure) } }
    );
  }

  if (method === "POST" && path === "/api/logout") {
    const cookies = parseCookies(request.headers.get("Cookie"));
    const secure = new URL(request.url).protocol === "https:";
    if (cookies.session) {
      await env.DB.prepare(`DELETE FROM sessions WHERE token = ?`)
        .bind(cookies.session)
        .run();
    }
    return json(
      { ok: true },
      { headers: { "Set-Cookie": clearSessionCookie(secure) } }
    );
  }

  if (method === "GET" && path === "/api/me") {
    const auth = await getUserBySession(env, request);
    if (!auth) return error("Unauthorized", 401);
    return json({ user: auth.user });
  }

  if (method === "POST" && path === "/api/change-password") {
    const auth = await requireAuth(env, request);
    if (auth instanceof Response) return auth;

    const body = (await request.json().catch(() => null)) as {
      currentPassword?: string;
      newPassword?: string;
    } | null;

    if (!body?.currentPassword || !body?.newPassword) {
      return error("Current and new password are required");
    }
    
    const passwordCheck = validatePassword(body.newPassword);
    if (!passwordCheck.valid) return error(passwordCheck.error!);
    
    if (
      !(await verifyPassword(
        body.currentPassword,
        auth.row.password_salt,
        auth.row.password_hash
      ))
    ) {
      return error("Current password is incorrect", 401);
    }

    const { hash, salt } = await hashPassword(body.newPassword);
    await env.DB.prepare(
      `UPDATE users SET password_hash = ?, password_salt = ?, must_change_password = 0 WHERE id = ?`
    )
      .bind(hash, salt, auth.user.id)
      .run();

    return json({ ok: true, user: { ...auth.user, mustChangePassword: false } });
  }

  // ---- Packets list / create ----
  if (method === "GET" && path === "/api/packets") {
    const auth = await requireAuth(env, request);
    if (auth instanceof Response) return auth;

    // Heal stale Ready-for-Review packets that still have open items,
    // and promote In Progress packets that are already 100% complete.
    try {
      await revertReadyPacketsWithOpenItems(env);
      await promoteCompletePackets(env);
      // Keep watcher out of board vote grids on existing packets.
      await env.DB.prepare(
        `DELETE FROM votes
         WHERE voter_user_id = 'usr_watcher'
            OR lower(voter_name) = 'watcher'
            OR voter_user_id IN (
              SELECT id FROM users
              WHERE role = 'watcher' OR id = 'usr_watcher' OR lower(username) = 'watcher'
            )`
      ).run();
    } catch (err) {
      console.error("packet status reconcile failed", err);
    }

    const status = url.searchParams.get("status");
    let q = `SELECT * FROM packets`;
    const binds: string[] = [];
    if (status) {
      q += ` WHERE status = ?`;
      binds.push(status);
    }
    q += ` ORDER BY updated_at DESC`;

    const stmt = env.DB.prepare(q);
    const packets = (
      binds.length ? await stmt.bind(...binds).all<PacketRow>() : await stmt.all<PacketRow>()
    ).results;

    const specialties = await loadSpecialtiesMap(env);
    const details = [];
    for (const p of packets) {
      const items = (
        await env.DB.prepare(
          `SELECT * FROM packet_items WHERE packet_id = ? ORDER BY sort_order ASC`
        )
          .bind(p.id)
          .all<PacketItemRow>()
      ).results;
      const votes = (
        await env.DB.prepare(`SELECT * FROM votes WHERE packet_id = ?`)
          .bind(p.id)
          .all<VoteRow>()
      ).results;
      details.push(mapPacket(p, specialties, items, votes));
    }
    return json({ packets: details });
  }

  if (method === "POST" && path === "/api/packets") {
    const auth = await requireAdmin(env, request);
    if (auth instanceof Response) return auth;

    const body = (await request.json().catch(() => null)) as {
      providerName?: string;
      providerType?: string;
      specialty?: string;
      credentialingType?: string;
      privilegeBlocks?: string[];
      notes?: string;
    } | null;

    if (!body?.providerName?.trim()) return error("Provider name is required");
    if (!body.providerType || !["surgeon", "pa", "anesthesia"].includes(body.providerType)) {
      return error("Valid provider type is required");
    }
    const specialty = body.specialty;
    if (!specialty) return error("Valid specialty is required");
    const specialtyExists = await env.DB.prepare(
      `SELECT id FROM specialties WHERE key = ? AND active = 1`
    )
      .bind(specialty)
      .first();
    if (!specialtyExists) {
      return error("Valid specialty is required");
    }
    if (!body.credentialingType || !["new", "recred"].includes(body.credentialingType)) {
      return error("Credentialing type must be new or recred");
    }

    const packetId = newId("pkt");
    const blocks = Array.isArray(body.privilegeBlocks) ? body.privilegeBlocks : [];
    const checklist = await resolveChecklistForPacket(env, {
      credentialingType: body.credentialingType as "new" | "recred",
      specialty,
      packetId: null,
    });

    await env.DB.prepare(
      `INSERT INTO packets
        (id, provider_name, provider_type, specialty, credentialing_type, privilege_blocks, status, notes, created_by)
       VALUES (?, ?, ?, ?, ?, ?, 'in_progress', ?, ?)`
    )
      .bind(
        packetId,
        body.providerName.trim(),
        body.providerType,
        specialty,
        body.credentialingType,
        JSON.stringify(blocks),
        body.notes?.trim() || "",
        auth.user.id
      )
      .run();

    const itemStmts = checklist.map((c, i) =>
      env.DB.prepare(
        `INSERT INTO packet_items
          (id, packet_id, item_key, label, sort_order, status, notes, source_scope, source_def_id)
         VALUES (?, ?, ?, ?, ?, 'pending', '', ?, ?)`
      ).bind(
        newId("item"),
        packetId,
        c.key,
        c.label,
        i + 1,
        c.scope || "global",
        c.defId || null
      )
    );
    if (itemStmts.length) await env.DB.batch(itemStmts);
    await createVoteSlots(env, packetId);

    const specialtyLabel = (
      await env.DB.prepare(`SELECT label FROM specialties WHERE key = ?`)
        .bind(specialty)
        .first<{ label: string }>()
    )?.label || specialty;

    await logPacketEvent(
      env,
      packetId,
      { id: auth.user.id, name: auth.user.displayName },
      "packet_created",
      `Opened credentialing packet for ${body.providerName.trim()}`,
      `${body.credentialingType === "new" ? "New credentialing" : "Recredentialing"} · ${specialtyLabel}`
    );

    const detail = await loadPacketDetail(env, packetId);
    return json({ packet: detail }, { status: 201 });
  }

  // ---- Packet by id ----
  const packetMatch = path.match(/^\/api\/packets\/([^/]+)(.*)$/);
  if (packetMatch) {
    const packetId = decodeURIComponent(packetMatch[1]);
    const rest = packetMatch[2] || "";

    if (method === "GET" && rest === "") {
      const auth = await requireAuth(env, request);
      if (auth instanceof Response) return auth;
      const detail = await loadPacketDetail(env, packetId);
      if (!detail) return error("Packet not found", 404);
      return json({ packet: detail });
    }

    if (method === "GET" && rest === "/activity") {
      const auth = await requireAuth(env, request);
      if (auth instanceof Response) return auth;
      const exists = await env.DB.prepare(`SELECT id FROM packets WHERE id = ?`)
        .bind(packetId)
        .first();
      if (!exists) return error("Packet not found", 404);
      const activity = await loadPacketActivity(env, packetId);
      return json({ activity });
    }

    if (method === "PATCH" && rest === "") {
      const auth = await requireAdminOrBoard(env, request);
      if (auth instanceof Response) return auth;

      const existing = await env.DB.prepare(`SELECT * FROM packets WHERE id = ?`)
        .bind(packetId)
        .first<PacketRow>();
      if (!existing) return error("Packet not found", 404);

      const body = (await request.json().catch(() => null)) as {
        providerName?: string;
        notes?: string;
        privilegeBlocks?: string[];
      } | null;

      const isBoard = auth.user.role === "board";
      if (isBoard) {
        // Board members may only update shared packet notes.
        if (body?.providerName !== undefined || body?.privilegeBlocks !== undefined) {
          return error("Governing board members may only update notes", 403);
        }
        if (body?.notes === undefined) {
          return error("Notes are required");
        }
      }

      const nextName =
        isBoard || body?.providerName === undefined
          ? existing.provider_name
          : body.providerName.trim() || existing.provider_name;
      const nextNotes = body?.notes !== undefined ? body.notes : existing.notes;
      const nextBlocks =
        isBoard || !body?.privilegeBlocks
          ? existing.privilege_blocks
          : JSON.stringify(body.privilegeBlocks);

      await env.DB.prepare(
        `UPDATE packets SET
           provider_name = ?,
           notes = ?,
           privilege_blocks = ?,
           updated_at = datetime('now')
         WHERE id = ?`
      )
        .bind(nextName, nextNotes, nextBlocks, packetId)
        .run();

      const changes: string[] = [];
      if (nextName !== existing.provider_name) changes.push(`Provider name → ${nextName}`);
      if (nextNotes !== existing.notes) changes.push("Updated notes");
      if (nextBlocks !== existing.privilege_blocks) changes.push("Updated privilege blocks");
      if (changes.length) {
        await logPacketEvent(
          env,
          packetId,
          { id: auth.user.id, name: auth.user.displayName },
          "packet_updated",
          isBoard ? "Updated packet notes" : "Updated packet details",
          changes.join("; ")
        );
      }

      return json({ packet: await loadPacketDetail(env, packetId) });
    }

    // Update checklist item
    const itemMatch = rest.match(/^\/items\/([^/]+)$/);
    if (method === "PATCH" && itemMatch) {
      const auth = await requireAdmin(env, request);
      if (auth instanceof Response) return auth;

      const itemId = decodeURIComponent(itemMatch[1]);
      const packet = await env.DB.prepare(`SELECT * FROM packets WHERE id = ?`)
        .bind(packetId)
        .first<PacketRow>();
      if (!packet) return error("Packet not found", 404);

      const body = (await request.json().catch(() => null)) as {
        status?: ItemStatus;
        notes?: string;
      } | null;

      if (body?.status && !["pending", "complete", "na"].includes(body.status)) {
        return error("Invalid item status");
      }

      const canEditStatus =
        packet.status === "in_progress" || packet.status === "query_pending";
      const canEditNotes =
        canEditStatus || packet.status === "ready_for_review";
      if (!canEditNotes) {
        return error("Checklist notes can only be edited before the packet is closed");
      }
      if (body?.status && !canEditStatus) {
        return error("Checklist status can only be edited while in progress or query pending");
      }

      const item = await env.DB.prepare(
        `SELECT * FROM packet_items WHERE id = ? AND packet_id = ?`
      )
        .bind(itemId, packetId)
        .first<PacketItemRow>();
      if (!item) return error("Checklist item not found", 404);

      const nextStatus = (
        body?.status && canEditStatus ? body.status : item.status
      ) as ItemStatus;
      const nextNotes = body?.notes !== undefined ? body.notes : item.notes;

      await env.DB.prepare(
        `UPDATE packet_items SET
           status = ?,
           notes = ?,
           updated_at = datetime('now')
         WHERE id = ?`
      )
        .bind(nextStatus, nextNotes, itemId)
        .run();

      await env.DB.prepare(
        `UPDATE packets SET updated_at = datetime('now') WHERE id = ?`
      )
        .bind(packetId)
        .run();

      if (nextStatus !== item.status || nextNotes !== item.notes) {
        const statusChanged = nextStatus !== item.status;
        const notesChanged = nextNotes !== item.notes;
        await logPacketEvent(
          env,
          packetId,
          { id: auth.user.id, name: auth.user.displayName },
          statusChanged ? "item_status_changed" : "packet_updated",
          statusChanged
            ? `Marked “${item.label}” ${ITEM_STATUS_LABELS[nextStatus]}`
            : `Updated notes on “${item.label}”`,
          notesChanged ? nextNotes.trim() : ""
        );
      }

      if (nextStatus !== item.status) {
        await autoMarkReadyIfComplete(env, packetId, {
          id: auth.user.id,
          name: auth.user.displayName,
        });
      }

      return json({ packet: await loadPacketDetail(env, packetId) });
    }

    if (method === "DELETE" && itemMatch) {
      const auth = await requireAdmin(env, request);
      if (auth instanceof Response) return auth;

      const itemId = decodeURIComponent(itemMatch[1]);
      const packet = await env.DB.prepare(`SELECT * FROM packets WHERE id = ?`)
        .bind(packetId)
        .first<PacketRow>();
      if (!packet) return error("Packet not found", 404);
      if (packet.status !== "in_progress" && packet.status !== "query_pending") {
        return error("Checklist items can only be deleted while in progress or query pending");
      }

      const item = await env.DB.prepare(
        `SELECT * FROM packet_items WHERE id = ? AND packet_id = ?`
      )
        .bind(itemId, packetId)
        .first<PacketItemRow>();
      if (!item) return error("Checklist item not found", 404);

      await env.DB.prepare(`DELETE FROM packet_items WHERE id = ?`)
        .bind(itemId)
        .run();

      await env.DB.prepare(
        `UPDATE packets SET updated_at = datetime('now') WHERE id = ?`
      )
        .bind(packetId)
        .run();

      await logPacketEvent(
        env,
        packetId,
        { id: auth.user.id, name: auth.user.displayName },
        "item_status_changed",
        `Removed checklist item: ${item.label}`,
        ""
      );

      await autoMarkReadyIfComplete(env, packetId, {
        id: auth.user.id,
        name: auth.user.displayName,
      });

      return json({ packet: await loadPacketDetail(env, packetId) });
    }

    // Mark ready for review
    if (method === "POST" && rest === "/ready") {
      const auth = await requireAdmin(env, request);
      if (auth instanceof Response) return auth;

      const detail = await loadPacketDetail(env, packetId);
      if (!detail) return error("Packet not found", 404);
      if (detail.status !== "in_progress" && detail.status !== "query_pending") {
        return error("Packet is not eligible to mark ready for review");
      }
      if (!detail.progress?.allDone || (detail.progress?.pendingRequired ?? 0) > 0) {
        return error(
          "Packet cannot be Ready for Review while any checklist items are still open (Pending)"
        );
      }

      // Clear prior pause votes when returning from query so board can re-vote
      if (detail.status === "query_pending") {
        await env.DB.prepare(
          `UPDATE votes SET vote = NULL, voted_at = NULL
           WHERE packet_id = ? AND vote = 'pause_for_query'`
        )
          .bind(packetId)
          .run();
      }

      await env.DB.prepare(
        `UPDATE packets SET status = 'ready_for_review', ready_at = datetime('now'),
           updated_at = datetime('now'), closed_at = NULL WHERE id = ?`
      )
        .bind(packetId)
        .run();

      await logPacketEvent(
        env,
        packetId,
        { id: auth.user.id, name: auth.user.displayName },
        "marked_ready",
        detail.status === "query_pending"
          ? "Returned packet to Ready for Review after query resolution"
          : "Marked packet Ready for Review",
        "All checklist components Complete or N/A"
      );

      return json({ packet: await loadPacketDetail(env, packetId) });
    }

    // Cast / update vote
    if (method === "POST" && rest === "/votes") {
      const auth = await requireAuth(env, request);
      if (auth instanceof Response) return auth;
      if (auth.user.role !== "board") return error("Only governing board members may vote", 403);

      const packet = await env.DB.prepare(`SELECT * FROM packets WHERE id = ?`)
        .bind(packetId)
        .first<PacketRow>();
      if (!packet) return error("Packet not found", 404);
      if (packet.status !== "ready_for_review" && packet.status !== "query_pending") {
        return error("Voting is only open for packets ready for review (or with an open query)");
      }
      if (packet.status === "ready_for_review" && (await packetHasOpenItems(env, packetId))) {
        await revertReadyPacketsWithOpenItems(env, packetId);
        return error(
          "This packet has open checklist items and was returned to In Progress; voting is closed",
          409
        );
      }

      const body = (await request.json().catch(() => null)) as {
        vote?: VoteChoice;
        concern?: string;
      } | null;

      if (!body?.vote || !["yes", "no", "pause_for_query"].includes(body.vote)) {
        return error("Vote must be yes, no, or pause_for_query");
      }
      if (body.vote === "pause_for_query" && !body.concern?.trim()) {
        return error("Describe the concerns that need to be queried");
      }

      const slot = await env.DB.prepare(
        `SELECT * FROM votes WHERE packet_id = ? AND voter_user_id = ?`
      )
        .bind(packetId, auth.user.id)
        .first<VoteRow>();
      if (!slot) return error("No vote slot found for this board member", 404);

      await env.DB.prepare(
        `UPDATE votes SET vote = ?, concern = ?, voted_at = datetime('now'),
           query_resolution = CASE WHEN ? = 'pause_for_query' THEN '' ELSE query_resolution END,
           resolution_at = CASE WHEN ? = 'pause_for_query' THEN NULL ELSE resolution_at END
         WHERE id = ?`
      )
        .bind(
          body.vote,
          body.vote === "pause_for_query" ? body.concern!.trim() : body.concern?.trim() || "",
          body.vote,
          body.vote,
          slot.id
        )
        .run();

      if (body.vote === "pause_for_query") {
        await logPacketEvent(
          env,
          packetId,
          { id: auth.user.id, name: auth.user.displayName },
          "query_opened",
          "Paused for query",
          body.concern!.trim()
        );
      } else {
        await logPacketEvent(
          env,
          packetId,
          { id: auth.user.id, name: auth.user.displayName },
          "vote_cast",
          `Voted ${VOTE_LABELS[body.vote]}`,
          body.concern?.trim() || ""
        );
      }

      await recomputePacketStatus(env, packetId);
      return json({ packet: await loadPacketDetail(env, packetId) });
    }

    // Resolve a query concern (admin)
    const resolveMatch = rest.match(/^\/votes\/([^/]+)\/resolve$/);
    if (method === "POST" && resolveMatch) {
      const auth = await requireAdmin(env, request);
      if (auth instanceof Response) return auth;

      const voteId = decodeURIComponent(resolveMatch[1]);
      const body = (await request.json().catch(() => null)) as {
        queryResolution?: string;
      } | null;
      if (!body?.queryResolution?.trim()) {
        return error("Query resolution notes are required");
      }

      const vote = await env.DB.prepare(
        `SELECT * FROM votes WHERE id = ? AND packet_id = ?`
      )
        .bind(voteId, packetId)
        .first<VoteRow>();
      if (!vote) return error("Vote not found", 404);
      if (vote.vote !== "pause_for_query") {
        return error("Only pause-for-query votes can receive a resolution");
      }

      await env.DB.prepare(
        `UPDATE votes SET query_resolution = ?, resolution_at = datetime('now') WHERE id = ?`
      )
        .bind(body.queryResolution.trim(), voteId)
        .run();

      await env.DB.prepare(
        `UPDATE packets SET updated_at = datetime('now') WHERE id = ?`
      )
        .bind(packetId)
        .run();

      await logPacketEvent(
        env,
        packetId,
        { id: auth.user.id, name: auth.user.displayName },
        "query_resolved",
        `Responded to ${vote.voter_name}'s query`,
        body.queryResolution.trim()
      );

      return json({ packet: await loadPacketDetail(env, packetId) });
    }

    // Get packet comments
    if (method === "GET" && rest === "/comments") {
      const auth = await requireAuth(env, request);
      if (auth instanceof Response) return auth;

      const exists = await env.DB.prepare(`SELECT id FROM packets WHERE id = ?`)
        .bind(packetId)
        .first();
      if (!exists) return error("Packet not found", 404);

      const comments = (
        await env.DB.prepare(
          `SELECT * FROM packet_comments WHERE packet_id = ? ORDER BY created_at ASC`
        )
          .bind(packetId)
          .all<PacketCommentRow>()
      ).results;

      return json({
        comments: comments.map((c) => ({
          id: c.id,
          packetId: c.packet_id,
          userId: c.user_id,
          userName: c.user_name,
          comment: c.comment,
          createdAt: c.created_at,
        })),
      });
    }

    // Post a comment (admin and board; watchers are read-only)
    if (method === "POST" && rest === "/comments") {
      const auth = await requireAuth(env, request);
      if (auth instanceof Response) return auth;
      if (auth.user.role === "watcher") {
        return error("Watchers have read-only access", 403);
      }

      const packet = await env.DB.prepare(`SELECT * FROM packets WHERE id = ?`)
        .bind(packetId)
        .first<PacketRow>();
      if (!packet) return error("Packet not found", 404);

      const body = (await request.json().catch(() => null)) as {
        comment?: string;
      } | null;

      const comment = body?.comment?.trim();
      if (!comment) return error("Comment is required");

      const commentId = newId("cmt");

      await env.DB.prepare(
        `INSERT INTO packet_comments (id, packet_id, user_id, user_name, comment)
         VALUES (?, ?, ?, ?, ?)`
      )
        .bind(commentId, packetId, auth.user.id, auth.user.displayName, comment)
        .run();

      await env.DB.prepare(
        `UPDATE packets SET updated_at = datetime('now') WHERE id = ?`
      )
        .bind(packetId)
        .run();

      await logPacketEvent(
        env,
        packetId,
        { id: auth.user.id, name: auth.user.displayName },
        "packet_updated",
        `${auth.user.displayName} added a comment`,
        comment
      );

      const newComment = await env.DB.prepare(
        `SELECT * FROM packet_comments WHERE id = ?`
      )
        .bind(commentId)
        .first<PacketCommentRow>();

      return json(
        {
          comment: {
            id: newComment!.id,
            packetId: newComment!.packet_id,
            userId: newComment!.user_id,
            userName: newComment!.user_name,
            comment: newComment!.comment,
            createdAt: newComment!.created_at,
          },
        },
        { status: 201 }
      );
    }

    if (method === "DELETE" && rest === "") {
      const auth = await requireAdmin(env, request);
      if (auth instanceof Response) return auth;
      await env.DB.prepare(`DELETE FROM packets WHERE id = ?`).bind(packetId).run();
      return json({ ok: true });
    }
  }

  return error("Not found", 404);
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname.startsWith("/api/")) {
      try {
        return await handleApi(request, env);
      } catch (err) {
        console.error(err);
        return error(err instanceof Error ? err.message : "Server error", 500);
      }
    }

    // Let the assets binding serve the SPA / static files
    return env.ASSETS.fetch(request);
  },
};
