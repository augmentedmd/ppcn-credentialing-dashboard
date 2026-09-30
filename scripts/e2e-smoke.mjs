#!/usr/bin/env node
const BASE = "http://127.0.0.1:8787";

function parseSetCookie(res) {
  const raw = res.headers.getSetCookie?.() || [];
  const cookies = [];
  for (const c of raw) cookies.push(c.split(";")[0]);
  // fallback for older undici
  const single = res.headers.get("set-cookie");
  if (!raw.length && single) cookies.push(single.split(";")[0]);
  return cookies.filter(Boolean).join("; ");
}

async function req(path, { method = "GET", body, cookie } = {}) {
  const headers = { "Content-Type": "application/json" };
  if (cookie) headers.Cookie = cookie;
  const res = await fetch(BASE + path, {
    method,
    headers,
    body: body ? JSON.stringify(body) : undefined,
  });
  const set = parseSetCookie(res);
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(`${method} ${path}: ${data.error || res.status}`);
  return { data, cookie: set || cookie || "" };
}

async function main() {
  console.log("health", (await req("/api/health")).data);

  let admin = await req("/api/login", {
    method: "POST",
    body: { username: "admin", password: "ChangeMeAdmin1!" },
  });
  console.log("login", admin.data.user.username);
  let cookie = admin.cookie;

  // If password already changed from a prior run, try the new one
  if (!cookie) throw new Error("no session cookie");

  try {
    const pw = await req("/api/change-password", {
      method: "POST",
      cookie,
      body: {
        currentPassword: "ChangeMeAdmin1!",
        newPassword: "AdminSecure99!",
      },
    });
    console.log("password changed", pw.data.ok);
  } catch (e) {
    // re-login with new password if already changed
    admin = await req("/api/login", {
      method: "POST",
      body: { username: "admin", password: "AdminSecure99!" },
    });
    cookie = admin.cookie;
    console.log("relogin with rotated password");
  }

  const created = await req("/api/packets", {
    method: "POST",
    cookie,
    body: {
      providerName: "Alex Rivera, MD",
      providerType: "surgeon",
      specialty: "urology",
      credentialingType: "new",
      privilegeBlocks: ["Urology — Core Privileges", "Fluoroscopy"],
      notes: "Test packet",
    },
  });
  const packet = created.data.packet;
  console.log("created", packet.id, "items", packet.items.length);

  for (const item of packet.items) {
    await req(`/api/packets/${packet.id}/items/${item.id}`, {
      method: "PATCH",
      cookie,
      body: { status: "complete" },
    });
  }

  let ready = await req(`/api/packets/${packet.id}/ready`, {
    method: "POST",
    cookie,
  });
  console.log("ready", ready.data.packet.status, ready.data.packet.progress);

  let board = await req("/api/login", {
    method: "POST",
    body: { username: "michael.gorin", password: "ChangeMeBoard1!" },
  });
  const pause = await req(`/api/packets/${packet.id}/votes`, {
    method: "POST",
    cookie: board.cookie,
    body: {
      vote: "pause_for_query",
      concern: "Need updated Quantiferon date confirmation",
    },
  });
  console.log("pause status", pause.data.packet.status);

  const vote = pause.data.packet.votes.find((v) => v.vote === "pause_for_query");
  const resolved = await req(
    `/api/packets/${packet.id}/votes/${vote.id}/resolve`,
    {
      method: "POST",
      cookie,
      body: {
        queryResolution:
          "Lab uploaded Quantiferon dated within 3 months; verified on chart.",
      },
    }
  );
  console.log(
    "resolved",
    resolved.data.packet.status,
    resolved.data.packet.votes.find((v) => v.queryResolution)?.queryResolution.slice(0, 40)
  );

  ready = await req(`/api/packets/${packet.id}/ready`, { method: "POST", cookie });
  console.log("re-ready", ready.data.packet.status);

  for (const username of [
    "ken.long",
    "michael.gorin",
    "michael.herman",
    "vijay.mukhija",
    "stelios.koutsoumbelis",
  ]) {
    const login = await req("/api/login", {
      method: "POST",
      body: { username, password: "ChangeMeBoard1!" },
    });
    await req(`/api/packets/${packet.id}/votes`, {
      method: "POST",
      cookie: login.cookie,
      body: { vote: "yes" },
    });
  }

  const final = await req(`/api/packets/${packet.id}`, { cookie });
  console.log(
    "FINAL",
    final.data.packet.status,
    final.data.packet.votes.map((v) => v.vote).join(",")
  );

  for (const path of ["/", "/login.html", "/styles.css", "/assets/logo.png", "/js/app.js"]) {
    const res = await fetch(BASE + path);
    console.log("asset", path, res.status);
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
