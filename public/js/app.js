const STATUS_LABELS = {
  in_progress: "In Progress",
  ready_for_review: "Ready for Review",
  query_pending: "Pause for Query",
  approved: "Approved",
  denied: "Denied",
};

const VOTE_LABELS = {
  yes: "Yes",
  no: "No",
  pause_for_query: "Pause for Query",
  none: "Awaiting vote",
};

const SPECIALTY_BY_PROVIDER = {
  surgeon: [
    "gen_surg",
    "gi",
    "gyn",
    "ent",
    "ortho",
    "ophthalmology",
    "plastic",
    "podiatry",
    "urology",
    "pain",
  ],
  pa: ["pa"],
  anesthesia: ["anesthesia_physician", "anesthesia_crna"],
};

let state = {
  user: null,
  meta: null,
  packets: [],
  filter: "all",
  specialtyFilter: "all",
  nameQuery: "",
  minPct: 0,
  sortBy: "updatedAt", // name | specialty | pct | status | updatedAt | createdAt
  sortDir: "desc", // asc | desc
  view: "list", // list | detail | password | checklist
  packetId: null,
  modal: null,
  activity: null,
  checklistDefs: [],
};

const app = document.getElementById("app");

async function api(path, options = {}) {
  const res = await fetch(path, {
    credentials: "same-origin",
    headers: {
      "Content-Type": "application/json",
      ...(options.headers || {}),
    },
    ...options,
  });
  const data = await res.json().catch(() => ({}));
  if (res.status === 401 && !path.includes("/login")) {
    const err = new Error(data.error || "Unauthorized");
    err.status = 401;
    // Avoid bouncing login <-> app on transient API failures.
    if (!options.skipAuthRedirect) {
      location.replace("/login.html");
    }
    throw err;
  }
  if (!res.ok) {
    const err = new Error(data.error || `Request failed (${res.status})`);
    err.status = res.status;
    throw err;
  }
  return data;
}

function esc(s) {
  return String(s ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function statusBadge(status, pct = null) {
  if (status === "in_progress" && pct != null) {
    const color = progressColor(pct);
    const bg = `color-mix(in srgb, ${color} 18%, white)`;
    return `<span class="status in_progress" style="background:${bg};color:${color};border:1px solid color-mix(in srgb, ${color} 35%, white)">${esc(STATUS_LABELS[status])}</span>`;
  }
  return `<span class="status ${esc(status)}">${esc(STATUS_LABELS[status] || status)}</span>`;
}

/** Ready for Review is invalid while any checklist item is still Pending. */
function effectiveStatus(packet) {
  if (
    packet.status === "ready_for_review" &&
    ((packet.progress?.pendingRequired ?? 0) > 0 || packet.progress?.allDone === false)
  ) {
    return "in_progress";
  }
  return packet.status;
}

function isReadyForReview(packet) {
  return effectiveStatus(packet) === "ready_for_review";
}

function progressPct(packet) {
  if (!packet.progress || !packet.progress.total) return 0;
  return Math.round((packet.progress.completed / packet.progress.total) * 100);
}

/** Red → amber → green based on completion percent. */
function progressColor(pct) {
  const p = Math.max(0, Math.min(100, Number(pct) || 0)) / 100;
  const red = [180, 35, 24];
  const amber = [183, 121, 31];
  const green = [38, 139, 107];
  const mix = (a, b, t) =>
    a.map((v, i) => Math.round(v + (b[i] - v) * t));
  const rgb = p < 0.5 ? mix(red, amber, p / 0.5) : mix(amber, green, (p - 0.5) / 0.5);
  return `rgb(${rgb[0]}, ${rgb[1]}, ${rgb[2]})`;
}

function progressLabel(packet) {
  const completed = packet.progress?.completed || 0;
  const total = packet.progress?.total || 0;
  const pct = progressPct(packet);
  const voteSummary =
    packet.votes?.length != null
      ? ` · ${packet.votes.filter((v) => v.vote).length}/${packet.votes.length} votes`
      : "";
  return `${completed}/${total} (${pct}%)${voteSummary}`;
}

function formatWhen(iso) {
  if (!iso) return "";
  const raw = /Z$|[+-]\d{2}:\d{2}$/.test(iso) ? iso : `${iso.replace(" ", "T")}Z`;
  const d = new Date(raw);
  if (Number.isNaN(d.getTime())) return iso;
  return d.toLocaleString(undefined, {
    month: "short",
    day: "numeric",
    year: "numeric",
    hour: "numeric",
    minute: "2-digit",
  });
}

const EVENT_TYPE_LABELS = {
  packet_created: "Created",
  packet_updated: "Updated",
  item_status_changed: "Checklist",
  marked_ready: "Ready",
  vote_cast: "Vote",
  query_opened: "Query",
  query_resolved: "Response",
  status_changed: "Status",
};

async function bootstrap() {
  try {
    const me = await api("/api/me", { skipAuthRedirect: true });
    state.user = me.user;
    if (state.user.mustChangePassword) {
      state.view = "password";
      render();
      return;
    }
    state.meta = await api("/api/meta");
    await refreshPackets();
    sessionStorage.removeItem("ppcn_auth_hop");
    render();
  } catch (err) {
    // Only send unauthenticated users to login. Other errors used to cause a
    // login <-> dashboard redirect loop (blinking page).
    if (err?.status === 401) {
      location.replace("/login.html");
      return;
    }
    console.error(err);
    app.innerHTML = `
      <div class="loading-screen" style="gap:12px;padding:32px;text-align:center">
        <div>Couldn’t load the dashboard.</div>
        <div style="color:var(--muted);font-size:0.95rem">${esc(err?.message || "Unknown error")}</div>
        <div class="btn-row" style="justify-content:center">
          <button class="btn primary" type="button" id="retry-bootstrap">Try again</button>
          <a class="btn ghost" href="/login.html">Back to sign in</a>
        </div>
      </div>`;
    document.getElementById("retry-bootstrap")?.addEventListener("click", () => {
      app.innerHTML = `<div class="loading-screen">Loading secure dashboard…</div>`;
      bootstrap();
    });
  }
}

async function refreshPackets() {
  const data = await api("/api/packets");
  state.packets = data.packets || [];
}

function currentPacket() {
  return state.packets.find((p) => p.id === state.packetId) || null;
}

function shell(content) {
  return `
    <header class="topbar">
      <div class="topbar-inner">
        <div class="brand-lockup">
          <img src="/assets/logo.png" alt="PeakPoint Central Nassau Surgery Center">
          <div class="brand-copy">
            <div class="org">PeakPoint Central Nassau</div>
            <div class="app-name">Credentialing Dashboard</div>
          </div>
        </div>
        <div class="user-chip">
          <div class="user-meta">
            <strong>${esc(state.user.displayName)}</strong>
            <span>${
              state.user.role === "admin"
                ? "Credentialing staff"
                : state.user.role === "watcher"
                  ? "Watcher"
                  : "Governing board"
            }</span>
          </div>
          <button class="btn ghost sm" data-action="change-password">Password</button>
          <button class="btn ghost sm" data-action="logout">Sign out</button>
        </div>
      </div>
    </header>
    <main class="page">${content}</main>
    ${state.modal || ""}
  `;
}

function render() {
  if (state.view === "password") {
    app.innerHTML = shell(renderPasswordForm(true));
    bind();
    return;
  }
  if (state.view === "checklist") {
    app.innerHTML = shell(renderChecklistAdmin());
    bind();
    return;
  }
  if (state.view === "detail") {
    const packet = currentPacket();
    app.innerHTML = shell(packet ? renderDetail(packet) : `<div class="empty">Packet not found.</div>`);
    bind();
    return;
  }
  app.innerHTML = shell(renderList());
  bind();
}

function renderPasswordForm(forced) {
  return `
    <div class="detail-hero" style="max-width:520px;margin:40px auto">
      <div class="app-name" style="color:var(--green-d);font-weight:700;letter-spacing:.04em;text-transform:uppercase;font-size:.82rem">Account security</div>
      <h2 style="margin:8px 0 4px;font-family:var(--display);color:var(--slate)">Change password</h2>
      <p style="color:var(--muted);margin:0 0 16px">${forced ? "You must set a new password before continuing." : "Update your sign-in password."}</p>
      <form id="password-form" class="auth-card" style="box-shadow:none;padding:0;border:0">
        <label class="fld"><span>Current password</span><input type="password" name="currentPassword" required autocomplete="current-password"></label>
        <label class="fld"><span>New password (min 10 characters)</span><input type="password" name="newPassword" required minlength="10" autocomplete="new-password"></label>
        <label class="fld"><span>Confirm new password</span><input type="password" name="confirmPassword" required minlength="10" autocomplete="new-password"></label>
        <p class="form-error" id="pw-error" hidden></p>
        <div class="btn-row">
          <button class="btn primary" type="submit">Save password</button>
          ${forced ? "" : `<button class="btn ghost" type="button" data-action="close-password">Cancel</button>`}
        </div>
      </form>
    </div>
  `;
}

function filteredSortedPackets() {
  const q = state.nameQuery.trim().toLowerCase();
  let packets = state.packets.filter((p) => {
    const status = effectiveStatus(p);
    if (state.filter === "ready_for_review") {
      if (!isReadyForReview(p)) return false;
    } else if (state.filter !== "all" && status !== state.filter) {
      return false;
    }
    if (state.specialtyFilter !== "all" && p.specialty !== state.specialtyFilter) return false;
    if (progressPct(p) < Number(state.minPct || 0)) return false;
    if (q && !String(p.providerName || "").toLowerCase().includes(q)) return false;
    return true;
  });

  const dir = state.sortDir === "asc" ? 1 : -1;
  const statusOrder = {
    in_progress: 1,
    ready_for_review: 2,
    query_pending: 3,
    approved: 4,
    denied: 5,
  };

  packets = packets.slice().sort((a, b) => {
    let av;
    let bv;
    switch (state.sortBy) {
      case "name":
        av = (a.providerName || "").toLowerCase();
        bv = (b.providerName || "").toLowerCase();
        break;
      case "specialty":
        av = (a.specialtyLabel || a.specialty || "").toLowerCase();
        bv = (b.specialtyLabel || b.specialty || "").toLowerCase();
        break;
      case "pct":
        av = progressPct(a);
        bv = progressPct(b);
        break;
      case "status":
        av = statusOrder[a.status] || 99;
        bv = statusOrder[b.status] || 99;
        break;
      case "createdAt":
        av = a.createdAt || "";
        bv = b.createdAt || "";
        break;
      case "updatedAt":
      default:
        av = a.updatedAt || "";
        bv = b.updatedAt || "";
        break;
    }
    if (av < bv) return -1 * dir;
    if (av > bv) return 1 * dir;
    return 0;
  });

  return packets;
}

function renderList() {
  const filters = [
    ["all", "All"],
    ["in_progress", "In Progress"],
    ["ready_for_review", "Ready for Review"],
    ["query_pending", "Query"],
    ["approved", "Approved"],
    ["denied", "Denied"],
  ];

  const packets = filteredSortedPackets();
  const readyCount = state.packets.filter((p) => isReadyForReview(p)).length;
  const specialties = state.meta?.specialties || {};

  return `
    <div class="page-head">
      <div>
        <h2>Credentialing packets</h2>
        <p>Track application components and governing board votes.</p>
      </div>
      <div class="btn-row">
        ${
          state.user.role === "admin"
            ? `<button class="btn ghost" data-action="open-checklist-admin">Checklist items</button>
               <button class="btn primary" data-action="new-packet">New packet</button>`
            : ""
        }
      </div>
    </div>
    ${
      readyCount && state.user.role === "board"
        ? `<div class="banner info">${readyCount} packet${readyCount === 1 ? "" : "s"} ready for your review.</div>`
        : ""
    }
    <div class="filters">
      ${filters
        .map(
          ([id, label]) =>
            `<button class="chip ${state.filter === id ? "active" : ""}" data-action="filter" data-filter="${id}">${label}</button>`
        )
        .join("")}
    </div>
    <div class="list-controls">
      <label class="ctl">
        <span>Provider name</span>
        <input type="search" id="filter-name" value="${esc(state.nameQuery)}" placeholder="Search name…">
      </label>
      <label class="ctl">
        <span>Specialty</span>
        <select id="filter-specialty">
          <option value="all">All specialties</option>
          ${Object.entries(specialties)
            .map(
              ([k, v]) =>
                `<option value="${esc(k)}" ${state.specialtyFilter === k ? "selected" : ""}>${esc(v)}</option>`
            )
            .join("")}
        </select>
      </label>
      <label class="ctl">
        <span>Min % complete</span>
        <input type="number" id="filter-min-pct" min="0" max="100" step="1" value="${esc(state.minPct)}">
      </label>
      <label class="ctl">
        <span>Sort by</span>
        <select id="sort-by">
          <option value="name" ${state.sortBy === "name" ? "selected" : ""}>Provider name</option>
          <option value="specialty" ${state.sortBy === "specialty" ? "selected" : ""}>Specialty</option>
          <option value="pct" ${state.sortBy === "pct" ? "selected" : ""}>% Completed</option>
          <option value="status" ${state.sortBy === "status" ? "selected" : ""}>Status</option>
          <option value="updatedAt" ${state.sortBy === "updatedAt" ? "selected" : ""}>Date of last activity</option>
          <option value="createdAt" ${state.sortBy === "createdAt" ? "selected" : ""}>Date of creation</option>
        </select>
      </label>
      <label class="ctl">
        <span>Direction</span>
        <select id="sort-dir">
          <option value="asc" ${state.sortDir === "asc" ? "selected" : ""}>Ascending</option>
          <option value="desc" ${state.sortDir === "desc" ? "selected" : ""}>Descending</option>
        </select>
      </label>
    </div>
    <div class="packet-grid">
      ${
        packets.length
          ? packets.map(renderPacketCard).join("")
          : `<div class="empty">No packets match these filters.</div>`
      }
    </div>
  `;
}

function renderPacketCard(p) {
  const pct = progressPct(p);
  const color = progressColor(pct);
  const status = effectiveStatus(p);
  return `
    <article class="packet-card" data-action="open-packet" data-id="${esc(p.id)}" tabindex="0" role="button">
      <div class="packet-card-top">
        <div>
          <h3>${esc(p.providerName)}</h3>
          <div class="meta">${esc(p.specialtyLabel)} · ${p.credentialingType === "new" ? "New credentialing" : "Recredentialing"}</div>
        </div>
        ${statusBadge(status, pct)}
      </div>
      <div class="progress-bar" aria-hidden="true"><span style="width:${pct}%;background:${color}"></span></div>
      <div class="progress-label">${esc(progressLabel(p))}</div>
    </article>
  `;
}

function renderDetail(p) {
  const status = effectiveStatus(p);
  const canEditItems =
    state.user.role === "admin" &&
    (status === "in_progress" || status === "query_pending");
  const canEditPacketNotes =
    state.user.role === "admin" &&
    (status === "in_progress" || status === "query_pending" || status === "ready_for_review");
  const canMarkReady =
    state.user.role === "admin" &&
    (status === "in_progress" || status === "query_pending") &&
    p.progress?.allDone;
  const canVote =
    state.user.role === "board" &&
    (status === "ready_for_review" || status === "query_pending");

  const openQueries = (p.votes || []).filter(
    (v) => v.vote === "pause_for_query" && !v.queryResolution
  );
  const resolvedQueries = (p.votes || []).filter(
    (v) => v.vote === "pause_for_query" && v.queryResolution
  );
  const allQueriesResolved =
    openQueries.length === 0 &&
    (p.votes || []).some((v) => v.vote === "pause_for_query" && v.queryResolution);

  return `
    <button class="btn ghost sm detail-back" data-action="back">← All packets</button>
    <section class="detail-hero">
      <div>${statusBadge(status, progressPct(p))}</div>
      <div class="detail-title-row">
        <h2>${esc(p.providerName)}</h2>
        <button type="button" class="activity-link" data-action="open-activity">Activity log</button>
      </div>
      <div class="meta">${esc(p.specialtyLabel)} · ${
        p.credentialingType === "new" ? "New credentialing" : "Recredentialing"
      }</div>
      <div class="meta-row">
        <span class="pill">${esc(p.providerType)}</span>
      </div>
      <div class="progress-bar detail-progress" aria-hidden="true"><span style="width:${progressPct(p)}%;background:${progressColor(progressPct(p))}"></span></div>
      <div class="progress-label">${esc(progressLabel(p))}</div>
      <div class="btn-row" style="margin-top:16px">
        ${
          canMarkReady && openQueries.length === 0
            ? `<button class="btn primary" data-action="mark-ready">${
                status === "query_pending"
                  ? "Return to Ready for Review"
                  : "Mark ready for review"
              }</button>`
            : ""
        }
        ${
          state.user.role === "admin" && status === "query_pending" && openQueries.length
            ? `<span class="progress-label">Respond to each open query below, then return the packet to review.</span>`
            : ""
        }
      </div>
    </section>

    <section class="section">
      <div class="section-h"><span>Notes</span></div>
      <div class="section-b">
        ${
          canEditPacketNotes
            ? `<form id="packet-notes-form" class="notes-form">
                <label class="fld">
                  <span>Internal notes for this packet</span>
                  <textarea name="notes" rows="2" placeholder="Add context for credentialing staff or the governing board…">${esc(p.notes || "")}</textarea>
                </label>
                <p class="form-error" id="packet-notes-error" hidden></p>
                <div class="btn-row">
                  <button class="btn primary sm" type="submit">Save notes</button>
                </div>
              </form>`
            : p.notes
              ? `<p class="notes-readonly">${esc(p.notes)}</p>`
              : `<p class="notes-empty">No notes yet.</p>`
        }
      </div>
    </section>

    ${
      openQueries.length || resolvedQueries.length
        ? renderQueryPanel(p, openQueries, resolvedQueries, allQueriesResolved)
        : ""
    }

    <section class="section">
      <div class="section-h"><span>Application components</span><span>${p.progress?.completed || 0}/${p.progress?.total || 0} (${progressPct(p)}%)</span></div>
      <div class="section-b check-list">
        ${(p.items || [])
          .map((item) => {
            return `
              <div class="check-row">
                <div>
                  <div class="label">${esc(item.label)}</div>
                  ${
                    item.sourceScope && item.sourceScope !== "global"
                      ? `<div class="notes">${item.sourceScope === "specialty" ? "Specialty item" : "Provider-specific item"}</div>`
                      : ""
                  }
                </div>
                <div class="item-status" data-item-id="${esc(item.id)}">
                  ${
                    canEditItems
                      ? ["pending", "complete", "na"]
                          .map((s) => {
                            const label =
                              s === "pending" ? "Pending" : s === "complete" ? "Done" : "N/A";
                            return `<button type="button" class="${item.status === s ? `on-${s}` : ""}" data-action="set-item" data-status="${s}" data-item="${esc(item.id)}">${label}</button>`;
                          })
                          .join("")
                      : `<span class="status ${item.status === "complete" ? "approved" : item.status === "na" ? "in_progress" : "query_pending"}">${item.status === "complete" ? "Complete" : item.status === "na" ? "N/A" : "Pending"}</span>`
                  }
                </div>
              </div>
            `;
          })
          .join("")}
        ${
          state.user.role === "admin" && canEditItems
            ? `<div class="btn-row" style="margin-top:4px">
                <button class="btn ghost sm" data-action="add-packet-item">Add item for this provider</button>
              </div>`
            : ""
        }
      </div>
    </section>

    <section class="section">
      <div class="section-h slate"><span>Governing board review</span><span>${(p.votes || []).filter((v) => v.vote).length}/${(p.votes || []).length}</span></div>
      <div class="section-b">
        ${
          status === "in_progress"
            ? `<div class="banner warn">Board voting unlocks when the packet is marked <strong>Ready for Review</strong>.</div>`
            : ""
        }
        <div class="vote-grid">
          ${(p.votes || []).map((v) => renderVoteCard(p, v, canVote)).join("")}
        </div>
      </div>
    </section>

    ${
      state.user.role === "admin"
        ? `<section class="section danger-zone">
            <div class="section-h danger"><span>Danger zone</span></div>
            <div class="section-b">
              <p class="danger-zone-copy">Permanently delete this credentialing packet and its checklist, votes, and activity log. This cannot be undone.</p>
              <button class="btn danger" data-action="delete-packet">Delete packet</button>
            </div>
          </section>`
        : ""
    }
  `;
}

function renderQueryPanel(packet, openQueries, resolvedQueries, allQueriesResolved) {
  const isAdmin = state.user.role === "admin";
  return `
    <section class="section query-section">
      <div class="section-h amber"><span>Queries &amp; holds</span><span>${openQueries.length} open</span></div>
      <div class="section-b">
        ${
          openQueries.length
            ? `<div class="banner warn">A governing board member paused this packet. ${
                isAdmin
                  ? "Post a written response for each concern, then return the packet to Ready for Review."
                  : "Credentialing staff will post a written response."
              }</div>`
            : allQueriesResolved
              ? `<div class="banner info">All open queries have a written response.${
                  isAdmin && packet.status === "query_pending"
                    ? " You can return the packet to Ready for Review for a re-vote."
                    : ""
                }</div>`
              : ""
        }
        <div class="query-list">
          ${openQueries.map((v) => renderOpenQueryCard(v, isAdmin)).join("")}
          ${resolvedQueries.map((v) => renderResolvedQueryCard(v)).join("")}
        </div>
      </div>
    </section>
  `;
}

function renderOpenQueryCard(vote, isAdmin) {
  return `
    <article class="query-card open" id="query-${esc(vote.id)}">
      <div class="query-card-head">
        <div>
          <strong>${esc(vote.voterName)}</strong>
          <span class="vote-choice pause_for_query">Pause for Query</span>
        </div>
        ${vote.votedAt ? `<time datetime="${esc(vote.votedAt)}">${esc(formatWhen(vote.votedAt))}</time>` : ""}
      </div>
      <div class="concern-box">
        <strong>Board concern</strong>
        <p>${esc(vote.concern)}</p>
      </div>
      ${
        isAdmin
          ? `
            <form class="query-response-form" data-vote-id="${esc(vote.id)}">
              <label class="fld">
                <span>Staff response</span>
                <textarea name="queryResolution" required rows="3" placeholder="Explain how the concern was addressed, what was uploaded, or the clarification provided…"></textarea>
              </label>
              <p class="form-error" hidden></p>
              <div class="btn-row">
                <button type="submit" class="btn primary sm">Post response</button>
              </div>
            </form>
          `
          : `<p class="progress-label">Awaiting credentialing staff response.</p>`
      }
    </article>
  `;
}

function renderResolvedQueryCard(vote) {
  return `
    <article class="query-card resolved">
      <div class="query-card-head">
        <div>
          <strong>${esc(vote.voterName)}</strong>
          <span class="pill">Resolved</span>
        </div>
        ${
          vote.resolutionAt
            ? `<time datetime="${esc(vote.resolutionAt)}">${esc(formatWhen(vote.resolutionAt))}</time>`
            : ""
        }
      </div>
      <div class="concern-box">
        <strong>Board concern</strong>
        <p>${esc(vote.concern)}</p>
      </div>
      <div class="resolution-box">
        <strong>Staff response</strong>
        <p>${esc(vote.queryResolution)}</p>
      </div>
    </article>
  `;
}

function renderVoteCard(packet, vote, canVote) {
  const isMine = vote.voterUserId === state.user.id;
  const choice = vote.vote || "none";
  const isOpenQuery = vote.vote === "pause_for_query" && !vote.queryResolution;
  return `
    <div class="vote-card ${isMine ? "mine" : ""}">
      <div class="vote-head">
        <strong>${esc(vote.voterName)}</strong>
        <span class="vote-choice ${choice}">${esc(VOTE_LABELS[choice])}</span>
      </div>
      ${
        vote.concern && !isOpenQuery
          ? `<div class="concern-box"><strong>Query / concern</strong><br>${esc(vote.concern)}</div>`
          : ""
      }
      ${
        isOpenQuery
          ? `<div class="concern-box"><strong>Open query</strong><br>${esc(vote.concern)}<div style="margin-top:8px"><a href="#query-${esc(vote.id)}">Jump to response</a></div></div>`
          : ""
      }
      ${
        vote.queryResolution
          ? `<div class="resolution-box"><strong>Query resolution</strong><br>${esc(vote.queryResolution)}</div>`
          : ""
      }
      ${
        isMine && canVote
          ? `
            <div class="btn-row">
              <button class="btn primary sm" data-action="vote" data-vote="yes">Yes</button>
              <button class="btn danger sm" data-action="vote" data-vote="no">No</button>
              <button class="btn warn sm" data-action="vote" data-vote="pause_for_query">Pause for Query</button>
            </div>
          `
          : ""
      }
    </div>
  `;
}

function renderChecklistAdmin() {
  const defs = state.checklistDefs || [];
  const globalNew = defs.filter((d) => d.scope === "global" && (d.credentialingType === "new" || d.credentialingType === "both"));
  const globalRecred = defs.filter((d) => d.scope === "global" && (d.credentialingType === "recred" || d.credentialingType === "both"));
  const specialty = defs.filter((d) => d.scope === "specialty");
  const packet = defs.filter((d) => d.scope === "packet");

  const packetName = (packetId) => {
    const p = (state.packets || []).find((x) => x.id === packetId);
    return p ? p.providerName : packetId;
  };

  const row = (d) => `
    <div class="check-row template-row">
      <div>
        <div class="label">${esc(d.label)}</div>
        <div class="notes">
          ${d.scope === "global" ? `Global · ${d.credentialingType}` : ""}
          ${d.scope === "specialty" ? `Specialty · ${esc(d.specialtyLabel || d.specialty)} · ${d.credentialingType}` : ""}
          ${d.scope === "packet" ? `Provider · ${esc(packetName(d.packetId))}` : ""}
        </div>
      </div>
      <div class="btn-row">
        <button class="btn danger sm" data-action="delete-checklist-def" data-id="${esc(d.id)}">Remove</button>
      </div>
    </div>`;

  return `
    <button class="btn ghost sm detail-back" data-action="back">← All packets</button>
    <div class="page-head">
      <div>
        <h2>Checklist items</h2>
        <p>Manage required components for all packets, one specialty, or a single provider.</p>
      </div>
      <button class="btn primary" data-action="new-checklist-def">Add checklist item</button>
    </div>
    <section class="section">
      <div class="section-h"><span>Global — new credentialing</span><span>${globalNew.length}</span></div>
      <div class="section-b check-list">${globalNew.length ? globalNew.map(row).join("") : `<div class="empty">No global new-credentialing items.</div>`}</div>
    </section>
    <section class="section">
      <div class="section-h slate"><span>Global — recredentialing</span><span>${globalRecred.length}</span></div>
      <div class="section-b check-list">${globalRecred.length ? globalRecred.map(row).join("") : `<div class="empty">No global recredentialing items.</div>`}</div>
    </section>
    <section class="section">
      <div class="section-h amber"><span>Specialty-specific</span><span>${specialty.length}</span></div>
      <div class="section-b check-list">${specialty.length ? specialty.map(row).join("") : `<div class="empty">No specialty-specific items yet.</div>`}</div>
    </section>
    <section class="section">
      <div class="section-h"><span>Provider-specific</span><span>${packet.length}</span></div>
      <div class="section-b check-list">${packet.length ? packet.map(row).join("") : `<div class="empty">No provider-only items. Add them from a packet detail page.</div>`}</div>
    </section>
  `;
}

function modalChecklistDef(defaults = {}) {
  const specialties = state.meta?.specialties || {};
  const packets = state.packets || [];
  const scope = defaults.scope || "global";
  return `
    <div class="modal-backdrop" data-action="close-modal">
      <form class="modal" id="checklist-def-form" data-stop>
        <h3>Add checklist item</h3>
        <p style="margin:0;color:var(--muted)">Choose whether this requirement applies to everyone, one specialty, or one provider.</p>
        <label class="fld"><span>Item label</span>
          <input name="label" required placeholder="Disclosure Response" value="${esc(defaults.label || "")}">
        </label>
        <label class="fld"><span>Applies to</span>
          <select name="scope" id="cdef-scope" required>
            <option value="global" ${scope === "global" ? "selected" : ""}>All packets (global)</option>
            <option value="specialty" ${scope === "specialty" ? "selected" : ""}>One specialty</option>
            <option value="packet" ${scope === "packet" ? "selected" : ""}>One provider</option>
          </select>
        </label>
        <label class="fld ${scope === "packet" ? "is-hidden" : ""}" id="cdef-type-wrap" ${scope === "packet" ? "hidden" : ""}>
          <span>Credentialing type</span>
          <select name="credentialingType" id="cdef-type" ${scope === "packet" ? "disabled" : ""}>
            <option value="both">New and recredentialing</option>
            <option value="new">New credentialing only</option>
            <option value="recred">Recredentialing only</option>
          </select>
        </label>
        <label class="fld ${scope === "specialty" ? "" : "is-hidden"}" id="cdef-specialty-wrap" ${scope === "specialty" ? "" : "hidden"}>
          <span>Specialty</span>
          <select name="specialty" id="cdef-specialty" ${scope === "specialty" ? "" : "disabled"}>
            <option value="">Select a specialty…</option>
            ${Object.entries(specialties)
              .map(
                ([k, v]) =>
                  `<option value="${esc(k)}" ${defaults.specialty === k ? "selected" : ""}>${esc(v)}</option>`
              )
              .join("")}
          </select>
        </label>
        <label class="fld ${scope === "packet" ? "" : "is-hidden"}" id="cdef-packet-wrap" ${scope === "packet" ? "" : "hidden"}>
          <span>Provider</span>
          <select name="packetId" id="cdef-packet" ${scope === "packet" ? "required" : "disabled"}>
            <option value="">Select a provider…</option>
            ${packets
              .map(
                (p) =>
                  `<option value="${esc(p.id)}" ${defaults.packetId === p.id ? "selected" : ""}>${esc(p.providerName)} — ${esc(p.specialtyLabel)}</option>`
              )
              .join("")}
          </select>
        </label>
        <label class="fld checkbox-row">
          <input type="checkbox" name="applyToExisting" checked>
          <span>Also add to matching existing open packets</span>
        </label>
        <p class="form-error" id="cdef-error" hidden></p>
        <div class="modal-actions">
          <button type="button" class="btn ghost" data-action="close-modal">Cancel</button>
          <button type="submit" class="btn primary">Save item</button>
        </div>
      </form>
    </div>
  `;
}

function modalNewPacket() {
  const specialties = state.meta?.specialties || {};
  return `
    <div class="modal-backdrop" data-action="close-modal">
      <form class="modal" id="new-packet-form" data-stop>
        <h3>New credentialing packet</h3>
        <label class="fld"><span>Provider name</span><input name="providerName" required placeholder="Jane Doe, MD"></label>
        <label class="fld"><span>Provider type</span>
          <select name="providerType" id="np-provider-type" required>
            <option value="surgeon">Surgeon</option>
            <option value="pa">Physician Assistant</option>
            <option value="anesthesia">Anesthesia Provider</option>
          </select>
        </label>
        <label class="fld"><span>Specialty / track</span>
          <select name="specialty" id="np-specialty" required></select>
        </label>
        <label class="fld"><span>Credentialing type</span>
          <select name="credentialingType" required>
            <option value="new">New credentialing</option>
            <option value="recred">Recredentialing</option>
          </select>
        </label>
        <label class="fld"><span>Notes</span><textarea name="notes" rows="2" placeholder="Optional internal notes"></textarea></label>
        <p class="form-error" id="np-error" hidden></p>
        <div class="modal-actions">
          <button type="button" class="btn ghost" data-action="close-modal">Cancel</button>
          <button type="submit" class="btn primary">Create packet</button>
        </div>
      </form>
    </div>
  `;
}

function fillSpecialtyOptions(providerType) {
  const sel = document.getElementById("np-specialty");
  if (!sel || !state.meta) return;
  const keys = SPECIALTY_BY_PROVIDER[providerType] || Object.keys(state.meta.specialties);
  sel.innerHTML = keys
    .map((k) => `<option value="${k}">${esc(state.meta.specialties[k] || k)}</option>`)
    .join("");
}

function modalPauseQuery() {
  return `
    <div class="modal-backdrop" data-action="close-modal">
      <form class="modal" id="pause-form" data-stop>
        <h3>Pause for query</h3>
        <p style="margin:0;color:var(--muted)">Describe the concerns that need to be queried and corrected before approval.</p>
        <label class="fld"><span>Concerns</span><textarea name="concern" required placeholder="List missing items, inconsistencies, or questions for credentialing staff…"></textarea></label>
        <p class="form-error" id="pause-error" hidden></p>
        <div class="modal-actions">
          <button type="button" class="btn ghost" data-action="close-modal">Cancel</button>
          <button type="submit" class="btn primary">Submit pause</button>
        </div>
      </form>
    </div>
  `;
}

function modalDeletePacket(packet) {
  return `
    <div class="modal-backdrop" data-action="close-modal">
      <form class="modal" id="delete-packet-form" data-stop>
        <h3>Delete packet</h3>
        <p style="margin:0;color:var(--muted)">
          This will permanently delete <strong>${esc(packet.providerName)}</strong> and all related checklist items, votes, and activity history.
        </p>
        <label class="fld">
          <span>Type DELETE PACKET to confirm</span>
          <input name="confirmText" required autocomplete="off" spellcheck="false" placeholder="DELETE PACKET">
        </label>
        <p class="form-error" id="delete-error" hidden></p>
        <div class="modal-actions">
          <button type="button" class="btn ghost" data-action="close-modal">Cancel</button>
          <button type="submit" class="btn danger">Delete permanently</button>
        </div>
      </form>
    </div>
  `;
}

function modalActivity(packet) {
  const activity = state.activity;
  let body = `<div class="empty">Loading activity…</div>`;
  if (activity?.error) {
    body = `<div class="banner warn">${esc(activity.error)}</div>`;
  } else if (activity && !activity.loading) {
    const events = activity.events || [];
    body = events.length
      ? `<ol class="activity-timeline">${events
          .map(
            (ev) => `
          <li class="activity-item type-${esc(ev.eventType)}">
            <div class="activity-meta">
              <span class="activity-type">${esc(EVENT_TYPE_LABELS[ev.eventType] || ev.eventType)}</span>
              <time datetime="${esc(ev.createdAt)}">${esc(formatWhen(ev.createdAt))}</time>
            </div>
            <div class="activity-summary">${esc(ev.summary)}</div>
            <div class="activity-actor">by ${esc(ev.actorName)}</div>
            ${ev.detail ? `<div class="activity-detail">${esc(ev.detail)}</div>` : ""}
          </li>`
          )
          .join("")}</ol>`
      : `<div class="empty">No activity recorded for this packet yet.</div>`;
  }

  return `
    <div class="modal-backdrop" data-action="close-modal">
      <div class="modal modal-wide" data-stop id="activity-modal">
        <div class="modal-title-row">
          <div>
            <h3>Activity log</h3>
            <p style="margin:4px 0 0;color:var(--muted)">${esc(packet.providerName)} — who changed what, and when</p>
          </div>
          <button type="button" class="btn ghost sm" data-action="close-modal">Close</button>
        </div>
        ${body}
      </div>
    </div>
  `;
}

function bind() {
  app.querySelectorAll("[data-action]").forEach((el) => {
    el.addEventListener("click", onAction);
    if (el.matches(".packet-card")) {
      el.addEventListener("keydown", (e) => {
        if (e.key === "Enter" || e.key === " ") {
          e.preventDefault();
          onAction(e);
        }
      });
    }
  });

  const pwForm = document.getElementById("password-form");
  if (pwForm) {
    pwForm.addEventListener("submit", async (e) => {
      e.preventDefault();
      const fd = new FormData(pwForm);
      const err = document.getElementById("pw-error");
      if (fd.get("newPassword") !== fd.get("confirmPassword")) {
        err.textContent = "New passwords do not match.";
        err.hidden = false;
        return;
      }
      try {
        const data = await api("/api/change-password", {
          method: "POST",
          body: JSON.stringify({
            currentPassword: fd.get("currentPassword"),
            newPassword: fd.get("newPassword"),
          }),
        });
        state.user = data.user;
        state.view = "list";
        state.meta = await api("/api/meta");
        await refreshPackets();
        render();
      } catch (ex) {
        err.textContent = ex.message;
        err.hidden = false;
      }
    });
  }

  const np = document.getElementById("new-packet-form");
  if (np) {
    fillSpecialtyOptions(document.getElementById("np-provider-type").value);
    document.getElementById("np-provider-type").addEventListener("change", (e) => {
      fillSpecialtyOptions(e.target.value);
    });
    np.addEventListener("click", (e) => e.stopPropagation());
    np.addEventListener("submit", async (e) => {
      e.preventDefault();
      const fd = new FormData(np);
      const err = document.getElementById("np-error");
      try {
        const data = await api("/api/packets", {
          method: "POST",
          body: JSON.stringify({
            providerName: fd.get("providerName"),
            providerType: fd.get("providerType"),
            specialty: fd.get("specialty"),
            credentialingType: fd.get("credentialingType"),
            privilegeBlocks: [],
            notes: fd.get("notes"),
          }),
        });
        state.modal = null;
        await refreshPackets();
        state.view = "detail";
        state.packetId = data.packet.id;
        render();
      } catch (ex) {
        err.textContent = ex.message;
        err.hidden = false;
      }
    });
  }

  const cdef = document.getElementById("checklist-def-form");
  if (cdef) {
    const syncScope = () => {
      const scope = document.getElementById("cdef-scope").value;
      const setVisible = (wrapId, inputId, visible, required = false) => {
        const wrap = document.getElementById(wrapId);
        const input = document.getElementById(inputId);
        if (!wrap || !input) return;
        wrap.hidden = !visible;
        wrap.classList.toggle("is-hidden", !visible);
        input.disabled = !visible;
        if (required) input.required = visible;
        else input.required = false;
      };
      setVisible("cdef-type-wrap", "cdef-type", scope !== "packet");
      setVisible("cdef-specialty-wrap", "cdef-specialty", scope === "specialty", true);
      setVisible("cdef-packet-wrap", "cdef-packet", scope === "packet", true);
    };
    syncScope();
    document.getElementById("cdef-scope").addEventListener("change", syncScope);
    cdef.addEventListener("click", (e) => e.stopPropagation());
    cdef.addEventListener("submit", async (e) => {
      e.preventDefault();
      const fd = new FormData(cdef);
      const err = document.getElementById("cdef-error");
      const scope = String(fd.get("scope"));
      if (scope === "specialty" && !fd.get("specialty")) {
        err.textContent = "Select a specialty.";
        err.hidden = false;
        return;
      }
      if (scope === "packet" && !fd.get("packetId")) {
        err.textContent = "Select a provider.";
        err.hidden = false;
        return;
      }
      try {
        await api("/api/checklist-defs", {
          method: "POST",
          body: JSON.stringify({
            label: fd.get("label"),
            scope,
            credentialingType: scope === "packet" ? "both" : fd.get("credentialingType"),
            specialty: scope === "specialty" ? fd.get("specialty") : null,
            packetId: scope === "packet" ? fd.get("packetId") : null,
            applyToExisting: fd.get("applyToExisting") === "on",
          }),
        });
        state.modal = null;
        await refreshPackets();
        if (state.view === "checklist") {
          const data = await api("/api/checklist-defs");
          state.checklistDefs = data.defs || [];
        }
        render();
      } catch (ex) {
        err.textContent = ex.message;
        err.hidden = false;
      }
    });
  }

  const nameInput = document.getElementById("filter-name");
  if (nameInput) {
    nameInput.addEventListener("input", () => {
      state.nameQuery = nameInput.value;
      render();
      const el = document.getElementById("filter-name");
      if (el) {
        el.focus();
        const len = el.value.length;
        el.setSelectionRange(len, len);
      }
    });
  }
  ["filter-specialty", "filter-min-pct", "sort-by", "sort-dir"].forEach((id) => {
    const el = document.getElementById(id);
    if (!el) return;
    el.addEventListener("change", () => {
      if (id === "filter-specialty") state.specialtyFilter = el.value;
      if (id === "filter-min-pct") state.minPct = Math.max(0, Math.min(100, Number(el.value) || 0));
      if (id === "sort-by") state.sortBy = el.value;
      if (id === "sort-dir") state.sortDir = el.value;
      render();
    });
  });

  const pause = document.getElementById("pause-form");
  if (pause) {
    pause.addEventListener("click", (e) => e.stopPropagation());
    pause.addEventListener("submit", async (e) => {
      e.preventDefault();
      const fd = new FormData(pause);
      const err = document.getElementById("pause-error");
      try {
        await castVote("pause_for_query", String(fd.get("concern") || ""));
        state.modal = null;
        render();
      } catch (ex) {
        err.textContent = ex.message;
        err.hidden = false;
      }
    });
  }

  const deleteForm = document.getElementById("delete-packet-form");
  if (deleteForm) {
    deleteForm.addEventListener("click", (e) => e.stopPropagation());
    deleteForm.addEventListener("submit", async (e) => {
      e.preventDefault();
      const fd = new FormData(deleteForm);
      const err = document.getElementById("delete-error");
      const typed = String(fd.get("confirmText") || "").trim();
      if (typed !== "DELETE PACKET") {
        err.textContent = 'Type DELETE PACKET exactly (all caps) to confirm.';
        err.hidden = false;
        return;
      }
      try {
        await api(`/api/packets/${state.packetId}`, { method: "DELETE" });
        state.packets = state.packets.filter((p) => p.id !== state.packetId);
        state.packetId = null;
        state.modal = null;
        state.view = "list";
        render();
      } catch (ex) {
        err.textContent = ex.message;
        err.hidden = false;
      }
    });
  }

  const activityModal = document.getElementById("activity-modal");
  if (activityModal) {
    activityModal.addEventListener("click", (e) => e.stopPropagation());
  }

  document.querySelectorAll(".query-response-form").forEach((form) => {
    form.addEventListener("submit", async (e) => {
      e.preventDefault();
      const voteId = form.getAttribute("data-vote-id");
      const fd = new FormData(form);
      const err = form.querySelector(".form-error");
      try {
        const data = await api(`/api/packets/${state.packetId}/votes/${voteId}/resolve`, {
          method: "POST",
          body: JSON.stringify({ queryResolution: fd.get("queryResolution") }),
        });
        replacePacket(data.packet);
        render();
      } catch (ex) {
        if (err) {
          err.textContent = ex.message;
          err.hidden = false;
        }
      }
    });
  });

  const packetNotesForm = document.getElementById("packet-notes-form");
  if (packetNotesForm) {
    packetNotesForm.addEventListener("submit", async (e) => {
      e.preventDefault();
      const fd = new FormData(packetNotesForm);
      const err = document.getElementById("packet-notes-error");
      const btn = packetNotesForm.querySelector('button[type="submit"]');
      try {
        if (btn) {
          btn.disabled = true;
          btn.textContent = "Saving…";
        }
        const data = await api(`/api/packets/${state.packetId}`, {
          method: "PATCH",
          body: JSON.stringify({ notes: String(fd.get("notes") || "") }),
        });
        replacePacket(data.packet);
        render();
      } catch (ex) {
        if (err) {
          err.textContent = ex.message;
          err.hidden = false;
        }
        if (btn) {
          btn.disabled = false;
          btn.textContent = "Save notes";
        }
      }
    });
  }
}

function replacePacket(packet) {
  const idx = state.packets.findIndex((p) => p.id === packet.id);
  if (idx >= 0) state.packets[idx] = packet;
  else state.packets.unshift(packet);
}

async function castVote(vote, concern = "") {
  const data = await api(`/api/packets/${state.packetId}/votes`, {
    method: "POST",
    body: JSON.stringify({ vote, concern }),
  });
  replacePacket(data.packet);
}

async function onAction(e) {
  const el = e.currentTarget;
  const action = el.getAttribute("data-action");
  if (!action) return;

  if (action === "logout") {
    await api("/api/logout", { method: "POST" });
    location.replace("/login.html");
    return;
  }

  if (action === "change-password") {
    state.view = "password";
    state.modal = null;
    render();
    return;
  }

  if (action === "close-password") {
    state.view = state.packetId ? "detail" : "list";
    render();
    return;
  }

  if (action === "filter") {
    state.filter = el.getAttribute("data-filter");
    render();
    return;
  }

  if (action === "open-packet") {
    state.packetId = el.getAttribute("data-id");
    state.view = "detail";
    render();
    return;
  }

  if (action === "back") {
    state.view = "list";
    state.packetId = null;
    await refreshPackets();
    render();
    return;
  }

  if (action === "new-packet") {
    state.modal = modalNewPacket();
    render();
    return;
  }

  if (action === "open-checklist-admin") {
    state.view = "checklist";
    state.modal = null;
    const data = await api("/api/checklist-defs");
    state.checklistDefs = data.defs || [];
    render();
    return;
  }

  if (action === "new-checklist-def") {
    state.modal = modalChecklistDef();
    render();
    return;
  }

  if (action === "add-packet-item") {
    state.modal = modalChecklistDef({ scope: "packet", packetId: state.packetId });
    render();
    return;
  }

  if (action === "delete-checklist-def") {
    const id = el.getAttribute("data-id");
    if (!confirm("Remove this checklist item from templates (and from packets that received it from this template)?")) return;
    await api(`/api/checklist-defs/${id}`, { method: "DELETE" });
    await refreshPackets();
    const data = await api("/api/checklist-defs");
    state.checklistDefs = data.defs || [];
    render();
    return;
  }

  if (action === "close-modal") {
    if (e.target !== el && el.classList.contains("modal-backdrop")) return;
    state.modal = null;
    state.activity = null;
    render();
    return;
  }

  if (action === "open-activity") {
    const packet = currentPacket();
    if (!packet) return;
    state.activity = { loading: true, events: [], error: null };
    state.modal = modalActivity(packet);
    render();
    try {
      const data = await api(`/api/packets/${packet.id}/activity`);
      state.activity = { loading: false, events: data.activity || [], error: null };
      state.modal = modalActivity(packet);
      render();
    } catch (ex) {
      state.activity = { loading: false, events: [], error: ex.message };
      state.modal = modalActivity(packet);
      render();
    }
    return;
  }

  if (action === "set-item") {
    const itemId = el.getAttribute("data-item");
    const status = el.getAttribute("data-status");
    const data = await api(`/api/packets/${state.packetId}/items/${itemId}`, {
      method: "PATCH",
      body: JSON.stringify({ status }),
    });
    replacePacket(data.packet);
    render();
    return;
  }

  if (action === "mark-ready") {
    if (!confirm("Mark this packet Ready for Review for the governing board?")) return;
    const data = await api(`/api/packets/${state.packetId}/ready`, { method: "POST" });
    replacePacket(data.packet);
    render();
    return;
  }

  if (action === "vote") {
    const vote = el.getAttribute("data-vote");
    if (vote === "pause_for_query") {
      state.modal = modalPauseQuery();
      render();
      return;
    }
    if (!confirm(`Record your vote as “${VOTE_LABELS[vote]}”?`)) return;
    await castVote(vote);
    render();
    return;
  }

  if (action === "delete-packet") {
    const packet = currentPacket();
    if (!packet) return;
    state.modal = modalDeletePacket(packet);
    render();
    return;
  }
}

bootstrap();
