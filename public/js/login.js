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
  if (!res.ok) {
    throw new Error(data.error || `Request failed (${res.status})`);
  }
  return data;
}

const form = document.getElementById("login-form");
const errEl = document.getElementById("login-error");
const btn = document.getElementById("login-btn");

function authHopCount() {
  return Number(sessionStorage.getItem("ppcn_auth_hop") || "0") || 0;
}

function bumpAuthHop() {
  const next = authHopCount() + 1;
  sessionStorage.setItem("ppcn_auth_hop", String(next));
  return next;
}

function clearAuthHop() {
  sessionStorage.removeItem("ppcn_auth_hop");
}

// If already signed in, go to dashboard — but bail out of redirect loops.
api("/api/me")
  .then(async () => {
    if (authHopCount() >= 2) {
      clearAuthHop();
      // Clear a sticky/broken session so the form is usable.
      try {
        await api("/api/logout", { method: "POST", body: "{}" });
      } catch {
        /* ignore */
      }
      errEl.textContent =
        "Sign-in hit a redirect loop, so the previous session was cleared. Please sign in again.";
      errEl.hidden = false;
      return;
    }
    bumpAuthHop();
    location.replace("/");
  })
  .catch(() => {
    clearAuthHop();
  });

form.addEventListener("submit", async (e) => {
  e.preventDefault();
  errEl.hidden = true;
  btn.disabled = true;
  btn.textContent = "Signing in…";
  try {
    await api("/api/login", {
      method: "POST",
      body: JSON.stringify({
        username: document.getElementById("username").value.trim(),
        password: document.getElementById("password").value,
      }),
    });
    clearAuthHop();
    location.replace("/");
  } catch (err) {
    errEl.textContent = err.message;
    errEl.hidden = false;
    btn.disabled = false;
    btn.textContent = "Sign in";
  }
});
