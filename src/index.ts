import {
  clearSessionCookie,
  error,
  json,
  parseCookies,
  sessionCookie,
  toPublicUser,
  hashPassword,
  verifyPassword,
} from "./auth";
import {
  BOARD_MEMBER_IDS,
  SPECIALTIES,
  checklistFor,
  newId,
} from "./checklist";
import type {
  Env,
  ItemStatus,
  PacketItemRow,
  PacketRow,
  PacketStatus,
  PublicUser,
  UserRow,
  VoteChoice,
  VoteRow,
} from "./types";

type Authed = { user: PublicUser; row: UserRow };

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

function mapItem(row: PacketItemRow) {
  return {
    id: row.id,
    key: row.item_key,
    label: row.label,
    sortOrder: row.sort_order,
    status: row.status,
    notes: row.notes,
    updatedAt: row.updated_at,
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
    specialtyLabel: SPECIALTIES[row.specialty] || row.specialty,
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

async function loadPacketDetail(env: Env, id: string) {
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
      `SELECT * FROM votes WHERE packet_id = ? ORDER BY voter_name ASC`
    )
      .bind(id)
      .all<VoteRow>()
  ).results;

  return mapPacket(packet, items, votes);
}

async function createVoteSlots(env: Env, packetId: string) {
  const board = (
    await env.DB.prepare(
      `SELECT id, display_name FROM users WHERE role = 'board' AND active = 1 ORDER BY display_name`
    ).all<{ id: string; display_name: string }>()
  ).results;

  const stmts = board.map((b) =>
    env.DB.prepare(
      `INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution)
       VALUES (?, ?, ?, ?, NULL, '', '')`
    ).bind(newId("vote"), packetId, b.id, b.display_name)
  );

  if (stmts.length) await env.DB.batch(stmts);
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

  const cast = votes.filter((v) => v.vote);
  const hasPause = cast.some((v) => v.vote === "pause_for_query");
  if (hasPause) {
    await env.DB.prepare(
      `UPDATE packets SET status = 'query_pending', updated_at = datetime('now'), closed_at = NULL WHERE id = ?`
    )
      .bind(packetId)
      .run();
    return "query_pending";
  }

  if (cast.length < votes.length || votes.length === 0) {
    await env.DB.prepare(
      `UPDATE packets SET status = 'ready_for_review', updated_at = datetime('now'), closed_at = NULL WHERE id = ?`
    )
      .bind(packetId)
      .run();
    return "ready_for_review";
  }

  if (cast.some((v) => v.vote === "no")) {
    await env.DB.prepare(
      `UPDATE packets SET status = 'denied', updated_at = datetime('now'), closed_at = datetime('now') WHERE id = ?`
    )
      .bind(packetId)
      .run();
    return "denied";
  }

  await env.DB.prepare(
    `UPDATE packets SET status = 'approved', updated_at = datetime('now'), closed_at = datetime('now') WHERE id = ?`
  )
    .bind(packetId)
    .run();
  return "approved";
}

async function handleApi(request: Request, env: Env): Promise<Response> {
  const url = new URL(request.url);
  const path = url.pathname;
  const method = request.method.toUpperCase();

  if (method === "GET" && path === "/api/health") {
    return json({ ok: true, app: env.APP_NAME || "PPCN Credentialing Dashboard" });
  }

  if (method === "GET" && path === "/api/meta") {
    return json({
      specialties: SPECIALTIES,
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
    if (body.newPassword.length < 10) {
      return error("New password must be at least 10 characters");
    }
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
      details.push(mapPacket(p, items, votes));
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
    if (!body.specialty || !SPECIALTIES[body.specialty]) {
      return error("Valid specialty is required");
    }
    if (!body.credentialingType || !["new", "recred"].includes(body.credentialingType)) {
      return error("Credentialing type must be new or recred");
    }

    const packetId = newId("pkt");
    const blocks = Array.isArray(body.privilegeBlocks) ? body.privilegeBlocks : [];
    const checklist = checklistFor(body.credentialingType as "new" | "recred");

    await env.DB.prepare(
      `INSERT INTO packets
        (id, provider_name, provider_type, specialty, credentialing_type, privilege_blocks, status, notes, created_by)
       VALUES (?, ?, ?, ?, ?, ?, 'in_progress', ?, ?)`
    )
      .bind(
        packetId,
        body.providerName.trim(),
        body.providerType,
        body.specialty,
        body.credentialingType,
        JSON.stringify(blocks),
        body.notes?.trim() || "",
        auth.user.id
      )
      .run();

    const itemStmts = checklist.map((c, i) =>
      env.DB.prepare(
        `INSERT INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes)
         VALUES (?, ?, ?, ?, ?, 'pending', '')`
      ).bind(newId("item"), packetId, c.key, c.label, i + 1)
    );
    if (itemStmts.length) await env.DB.batch(itemStmts);
    await createVoteSlots(env, packetId);

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

    if (method === "PATCH" && rest === "") {
      const auth = await requireAdmin(env, request);
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

      await env.DB.prepare(
        `UPDATE packets SET
           provider_name = ?,
           notes = ?,
           privilege_blocks = ?,
           updated_at = datetime('now')
         WHERE id = ?`
      )
        .bind(
          body?.providerName?.trim() || existing.provider_name,
          body?.notes !== undefined ? body.notes : existing.notes,
          body?.privilegeBlocks
            ? JSON.stringify(body.privilegeBlocks)
            : existing.privilege_blocks,
          packetId
        )
        .run();

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
      if (packet.status !== "in_progress" && packet.status !== "query_pending") {
        return error("Checklist can only be edited while in progress or query pending");
      }

      const body = (await request.json().catch(() => null)) as {
        status?: ItemStatus;
        notes?: string;
      } | null;

      if (body?.status && !["pending", "complete", "na"].includes(body.status)) {
        return error("Invalid item status");
      }

      const item = await env.DB.prepare(
        `SELECT * FROM packet_items WHERE id = ? AND packet_id = ?`
      )
        .bind(itemId, packetId)
        .first<PacketItemRow>();
      if (!item) return error("Checklist item not found", 404);

      await env.DB.prepare(
        `UPDATE packet_items SET
           status = ?,
           notes = ?,
           updated_at = datetime('now')
         WHERE id = ?`
      )
        .bind(
          body?.status || item.status,
          body?.notes !== undefined ? body.notes : item.notes,
          itemId
        )
        .run();

      await env.DB.prepare(
        `UPDATE packets SET updated_at = datetime('now') WHERE id = ?`
      )
        .bind(packetId)
        .run();

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
      if (!detail.progress?.allDone) {
        return error("All checklist items must be Complete or N/A before review");
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

      return json({ packet: await loadPacketDetail(env, packetId) });
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
