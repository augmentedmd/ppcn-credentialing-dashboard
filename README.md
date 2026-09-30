# PeakPoint Central Nassau — Credentialing Dashboard

Secure dashboard for tracking physician (and PA/CRNA) credentialing packet completeness and governing board votes at **PeakPoint Central Nassau Surgery Center**.

Part of the [AugmentedMD](https://github.com/augmentedmd/augmentedmd) tool panel. Created for Michael Gorin, MD.

## What it does

1. **Packet checklist** — For each provider application, track the documentation components from the [PPCN Privileging Requirements Guide](https://ppcn-credentialing.pages.dev/) (references, licenses, DOP, case log, health forms, etc.) as *Pending*, *Complete*, or *N/A*.
2. **Ready for review** — When every component is Complete or N/A, credentialing staff marks the packet **Ready for Review**.
3. **Governing board votes** — Ken Long, Michael Gorin, Michael Herman, Vijay Mukhija, and Stelios Koutsoumbelis each vote **Yes**, **No**, or **Pause for Query**.
4. **Query workflow** — Pause votes require written concerns; an **Open queries** panel lets staff post a written response on the packet; the packet can return to Ready for Review for re-vote.
5. **Activity log** — Each packet keeps a dated trail of checklist changes, votes, queries, and responses (open via **Activity log** next to the clinician’s name).
6. **Configurable checklist** — Admins manage required components globally, per specialty, or for a single provider (e.g. add “Disclosure Response”).
7. **Sort & filter** — Packet list can be sorted/filtered by provider name, specialty, % complete, status, last activity, and creation date.

## Stack

- Cloudflare **Workers** (API) + **static assets** (UI)
- Cloudflare **D1** (SQLite) for users, sessions, packets, checklist items, and votes
- Session cookie auth (HttpOnly, Secure, SameSite=Lax) with PBKDF2 password hashes

## Default accounts (change on first login)

| Username | Role | Temporary password |
|----------|------|--------------------|
| `admin` | Credentialing staff | `ChangeMeAdmin1!` |
| `ken.long` | Governing board | `ChangeMeBoard1!` |
| `michael.gorin` | Governing board | `ChangeMeBoard1!` |
| `michael.herman` | Governing board | `ChangeMeBoard1!` |
| `vijay.mukhija` | Governing board | `ChangeMeBoard1!` |
| `stelios.koutsoumbelis` | Governing board | `ChangeMeBoard1!` |

Users are prompted to change these passwords on first sign-in.

## Local development

```bash
npm install
npx wrangler d1 create ppcn-credentialing   # once; paste database_id into wrangler.toml
npm run db:migrate:local
npm run db:seed:local
npm run db:demo:local   # optional: sample packets across checklist / voting stages
npm run dev
```

Open the URL Wrangler prints (usually `http://127.0.0.1:8787`).

### Demo packets

`npm run db:demo:local` (or `db:demo:remote`) loads nine fictional applications covering blank → early → mid → nearly complete → checklist done → ready for review → query pending → approved → denied. Safe to re-run (`INSERT OR IGNORE`). Keep this off production unless you intentionally want sample clinical data.

## Deploy to Cloudflare (GitHub)

1. In the Cloudflare dashboard, create a Worker connected to this GitHub repository (`augmentedmd/ppcn-credentialing-dashboard`), or run:

   ```bash
   npx wrangler d1 create ppcn-credentialing
   # copy the database_id into wrangler.toml
   npm run db:migrate:remote
   npm run db:seed:remote
   npm run deploy
   ```

2. After deploy, sign in as `admin`, change the password, then have each board member change theirs.

3. Optional: add a custom domain in Workers → Settings → Domains.

4. Add a card on the AugmentedMD landing page pointing at the Worker URL (for example `https://ppcn-credentialing-dashboard.<account>.workers.dev` or your custom domain).

## API overview

| Method | Path | Who |
|--------|------|-----|
| POST | `/api/login` | Public |
| POST | `/api/logout` | Authenticated |
| GET | `/api/me` | Authenticated |
| POST | `/api/change-password` | Authenticated |
| GET/POST | `/api/packets` | Auth / admin create |
| GET | `/api/packets/:id/activity` | Auth — packet activity log |
| GET/POST | `/api/checklist-defs` | Auth list / admin create template items |
| PATCH/DELETE | `/api/checklist-defs/:id` | Admin update or remove template items |
| PATCH | `/api/packets/:id/items/:itemId` | Admin |
| POST | `/api/packets/:id/ready` | Admin |
| POST | `/api/packets/:id/votes` | Board |
| POST | `/api/packets/:id/votes/:voteId/resolve` | Admin |

## Branding

PeakPoint greens and greys (`#268B6B` / `#495566`) and the surgery center logo, consistent with the privileging guide and DOP tools.
