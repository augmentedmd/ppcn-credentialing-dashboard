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
  view: "list", // list | detail | password
  packetId: null,
  modal: null,
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
    location.replace("/login.html");
    throw new Error("Unauthorized");
  }
  if (!res.ok) throw new Error(data.error || `Request failed (${res.status})`);
  return data;
}

function esc(s) {
  return String(s ?? "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function statusBadge(status) {
  return `<span class="status ${esc(status)}">${esc(STATUS_LABELS[status] || status)}</span>`;
}

function progressPct(packet) {
  if (!packet.progress || !packet.progress.total) return 0;
  return Math.round((packet.progress.completed / packet.progress.total) * 100);
}

async function bootstrap() {
  try {
    const me = await api("/api/me");
    state.user = me.user;
    if (state.user.mustChangePassword) {
      state.view = "password";
      render();
      return;
    }
    state.meta = await api("/api/meta");
    await refreshPackets();
    render();
  } catch {
    location.replace("/login.html");
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
            <span>${state.user.role === "admin" ? "Credentialing staff" : "Governing board"}</span>
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

function renderList() {
  const filters = [
    ["all", "All"],
    ["in_progress", "In Progress"],
    ["ready_for_review", "Ready for Review"],
    ["query_pending", "Query"],
    ["approved", "Approved"],
    ["denied", "Denied"],
  ];

  const packets = state.packets.filter(
    (p) => state.filter === "all" || p.status === state.filter
  );

  const readyCount = state.packets.filter((p) => p.status === "ready_for_review").length;

  return `
    <div class="page-head">
      <div>
        <h2>Credentialing packets</h2>
        <p>Track application components and governing board votes.</p>
      </div>
      ${
        state.user.role === "admin"
          ? `<button class="btn primary" data-action="new-packet">New packet</button>`
          : ""
      }
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
    <div class="packet-grid">
      ${
        packets.length
          ? packets.map(renderPacketCard).join("")
          : `<div class="empty">No packets in this view yet.</div>`
      }
    </div>
  `;
}

function renderPacketCard(p) {
  const pct = progressPct(p);
  const voteSummary =
    p.votes?.filter((v) => v.vote).length != null
      ? `${p.votes.filter((v) => v.vote).length}/${p.votes.length} votes`
      : "";
  return `
    <article class="packet-card" data-action="open-packet" data-id="${esc(p.id)}" tabindex="0" role="button">
      <div class="packet-card-top">
        <div>
          <h3>${esc(p.providerName)}</h3>
          <div class="meta">${esc(p.specialtyLabel)} · ${p.credentialingType === "new" ? "New credentialing" : "Recredentialing"}</div>
        </div>
        ${statusBadge(p.status)}
      </div>
      <div class="progress-bar" aria-hidden="true"><span style="width:${pct}%"></span></div>
      <div class="progress-label">${p.progress?.completed || 0} of ${p.progress?.total || 0} components complete${voteSummary ? ` · ${voteSummary}` : ""}</div>
    </article>
  `;
}

function renderDetail(p) {
  const canEditItems =
    state.user.role === "admin" &&
    (p.status === "in_progress" || p.status === "query_pending");
  const canMarkReady =
    state.user.role === "admin" &&
    (p.status === "in_progress" || p.status === "query_pending") &&
    p.progress?.allDone;
  const canVote =
    state.user.role === "board" &&
    (p.status === "ready_for_review" || p.status === "query_pending");

  const openQueries = (p.votes || []).filter(
    (v) => v.vote === "pause_for_query" && !v.queryResolution
  );

  return `
    <button class="btn ghost sm detail-back" data-action="back">← All packets</button>
    <section class="detail-hero">
      <div>${statusBadge(p.status)}</div>
      <h2>${esc(p.providerName)}</h2>
      <div class="meta">${esc(p.specialtyLabel)} · ${
        p.credentialingType === "new" ? "New credentialing" : "Recredentialing"
      }</div>
      <div class="meta-row">
        <span class="pill">${esc(p.providerType)}</span>
        ${(p.privilegeBlocks || [])
          .map((b) => `<span class="pill">${esc(b)}</span>`)
          .join("")}
      </div>
      ${
        p.notes
          ? `<p style="margin:14px 0 0;color:var(--muted)">${esc(p.notes)}</p>`
          : ""
      }
      <div class="btn-row" style="margin-top:16px">
        ${
          canMarkReady
            ? `<button class="btn primary" data-action="mark-ready">Mark ready for review</button>`
            : ""
        }
        ${
          state.user.role === "admin" && p.status === "in_progress" && !p.progress?.allDone
            ? `<span class="progress-label">Complete or mark N/A on every component before review.</span>`
            : ""
        }
        ${
          state.user.role === "admin"
            ? `<button class="btn danger sm" data-action="delete-packet">Delete packet</button>`
            : ""
        }
      </div>
    </section>

    <section class="section">
      <div class="section-h"><span>Application components</span><span>${p.progress?.completed || 0}/${p.progress?.total || 0}</span></div>
      <div class="section-b check-list">
        ${(p.items || [])
          .map((item) => {
            return `
              <div class="check-row">
                <div>
                  <div class="label">${esc(item.label)}</div>
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
                ${item.notes ? `<div class="notes">${esc(item.notes)}</div>` : ""}
              </div>
            `;
          })
          .join("")}
      </div>
    </section>

    <section class="section">
      <div class="section-h slate"><span>Governing board review</span><span>${(p.votes || []).filter((v) => v.vote).length}/${(p.votes || []).length}</span></div>
      <div class="section-b">
        ${
          p.status === "in_progress"
            ? `<div class="banner warn">Board voting unlocks when the packet is marked <strong>Ready for Review</strong>.</div>`
            : ""
        }
        ${
          openQueries.length && state.user.role === "admin"
            ? `<div class="banner warn">${openQueries.length} open quer${openQueries.length === 1 ? "y" : "ies"} need a written resolution before returning the packet to review.</div>`
            : ""
        }
        <div class="vote-grid">
          ${(p.votes || []).map((v) => renderVoteCard(p, v, canVote)).join("")}
        </div>
      </div>
    </section>
  `;
}

function renderVoteCard(packet, vote, canVote) {
  const isMine = vote.voterUserId === state.user.id;
  const choice = vote.vote || "none";
  return `
    <div class="vote-card ${isMine ? "mine" : ""}">
      <div class="vote-head">
        <strong>${esc(vote.voterName)}</strong>
        <span class="vote-choice ${choice}">${esc(VOTE_LABELS[choice])}</span>
      </div>
      ${
        vote.concern
          ? `<div class="concern-box"><strong>Query / concern</strong><br>${esc(vote.concern)}</div>`
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
              <button class="btn ghost sm" data-action="vote" data-vote="pause_for_query">Pause for Query</button>
            </div>
          `
          : ""
      }
      ${
        state.user.role === "admin" &&
        vote.vote === "pause_for_query" &&
        !vote.queryResolution
          ? `<button class="btn ghost sm" data-action="resolve-query" data-vote-id="${esc(vote.id)}">Record query resolution</button>`
          : ""
      }
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
        <label class="fld"><span>Privilege blocks requested (comma-separated)</span>
          <input name="privilegeBlocks" placeholder="Core privileges, Fluoroscopy">
        </label>
        <label class="fld"><span>Notes</span><textarea name="notes" placeholder="Optional internal notes"></textarea></label>
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

function modalResolve(voteId) {
  return `
    <div class="modal-backdrop" data-action="close-modal">
      <form class="modal" id="resolve-form" data-vote-id="${esc(voteId)}" data-stop>
        <h3>Query resolution</h3>
        <p style="margin:0;color:var(--muted)">Explain how the queried concerns were addressed or corrected.</p>
        <label class="fld"><span>Resolution</span><textarea name="queryResolution" required placeholder="Describe the correction, attached documents, or clarification provided…"></textarea></label>
        <p class="form-error" id="resolve-error" hidden></p>
        <div class="modal-actions">
          <button type="button" class="btn ghost" data-action="close-modal">Cancel</button>
          <button type="submit" class="btn primary">Save resolution</button>
        </div>
      </form>
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
      const blocks = String(fd.get("privilegeBlocks") || "")
        .split(",")
        .map((s) => s.trim())
        .filter(Boolean);
      try {
        const data = await api("/api/packets", {
          method: "POST",
          body: JSON.stringify({
            providerName: fd.get("providerName"),
            providerType: fd.get("providerType"),
            specialty: fd.get("specialty"),
            credentialingType: fd.get("credentialingType"),
            privilegeBlocks: blocks,
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

  const resolve = document.getElementById("resolve-form");
  if (resolve) {
    resolve.addEventListener("click", (e) => e.stopPropagation());
    resolve.addEventListener("submit", async (e) => {
      e.preventDefault();
      const fd = new FormData(resolve);
      const err = document.getElementById("resolve-error");
      const voteId = resolve.getAttribute("data-vote-id");
      try {
        const data = await api(`/api/packets/${state.packetId}/votes/${voteId}/resolve`, {
          method: "POST",
          body: JSON.stringify({ queryResolution: fd.get("queryResolution") }),
        });
        replacePacket(data.packet);
        state.modal = null;
        render();
      } catch (ex) {
        err.textContent = ex.message;
        err.hidden = false;
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

  if (action === "close-modal") {
    if (e.target !== el && el.classList.contains("modal-backdrop")) return;
    state.modal = null;
    render();
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

  if (action === "resolve-query") {
    state.modal = modalResolve(el.getAttribute("data-vote-id"));
    render();
    return;
  }

  if (action === "delete-packet") {
    if (!confirm("Delete this packet permanently?")) return;
    await api(`/api/packets/${state.packetId}`, { method: "DELETE" });
    state.packets = state.packets.filter((p) => p.id !== state.packetId);
    state.packetId = null;
    state.view = "list";
    render();
  }
}

bootstrap();
