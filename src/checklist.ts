import type {
  ChecklistDef,
  ChecklistDefRow,
  ChecklistScope,
  CredentialingType,
  Env,
} from "./types";
import { newId } from "./checklist-id";

export { newId } from "./checklist-id";

/** Fallback core packet components (used only if DB templates are empty). */
export const BASE_CHECKLIST: ChecklistDef[] = [
  { key: "references", label: "Three Professional References" },
  { key: "photo_id", label: "Government-issued Photo ID" },
  { key: "board_cert", label: "Proof of Board Certification" },
  { key: "nys_license", label: "New York State Medical/PA/CRNA License Certificate" },
  { key: "dea", label: "DEA Certificate" },
  { key: "mandated_reporter", label: "Mandated Reporter Training Certificate" },
  {
    key: "malpractice",
    label:
      "Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)",
  },
  {
    key: "health_assessment",
    label: "Health Assessment (completed, dated, and signed by MD/DO/PA/NP)",
  },
  { key: "physical_exam", label: "Physical Examination Form" },
  { key: "quantiferon", label: "Quantiferon TB Test dated within 3 months" },
  { key: "immunizations", label: "Immunization Records — MMR, Hep B, and Influenza" },
  { key: "dop_form", label: "Delineation of Privileges (DOP) Form — signed and completed" },
  { key: "case_log", label: "Case Log (specialty template, when required)" },
  {
    key: "training_certs",
    label:
      "Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)",
  },
];

/** Fallback recredentialing checklist. */
export const RECRED_CHECKLIST: ChecklistDef[] = [
  { key: "dop_form", label: "Delineation of Privileges (DOP) Form — signed and completed" },
  { key: "case_log", label: "Case Log meeting renewal volume requirements" },
  { key: "board_cert", label: "Current Board Certification / MOC (as applicable)" },
  { key: "nys_license", label: "Current New York State License Certificate" },
  { key: "dea", label: "Current DEA Certificate (if applicable)" },
  { key: "malpractice", label: "Current Proof of Professional Liability Coverage" },
  {
    key: "health_assessment",
    label: "Health Assessment (completed, dated, and signed by MD/DO/PA/NP)",
  },
  { key: "physical_exam", label: "Physical Examination Form" },
  { key: "quantiferon", label: "Quantiferon TB Test dated within 3 months" },
  { key: "immunizations", label: "Immunization Records — MMR, Hep B, and Influenza" },
  {
    key: "training_certs",
    label:
      "Renewal training certificates if applicable (Fluoroscopy, Laser/Fire Safety, Chemo Admin, ACLS/BLS)",
  },
];

export const SPECIALTIES: Record<string, string> = {
  gen_surg: "General Surgery",
  gi: "Gastroenterology",
  gyn: "Gynecology",
  ent: "Otolaryngology",
  ortho: "Orthopedic Surgery",
  ophthalmology: "Ophthalmology",
  plastic: "Plastic Surgery",
  podiatry: "Podiatry",
  urology: "Urology",
  pain: "Pain Medicine",
  pa: "Physician Assistant",
  anesthesia_physician: "Anesthesiology — Physician (MD or DO)",
  anesthesia_crna: "Anesthesiology — CRNA",
};

export const PROVIDER_TYPES: Record<string, string> = {
  surgeon: "Surgeon",
  pa: "Physician Assistant",
  anesthesia: "Anesthesia Provider",
};

export const BOARD_MEMBER_IDS = [
  "usr_ken_long",
  "usr_michael_gorin",
  "usr_michael_herman",
  "usr_vijay_mukhija",
  "usr_stelios",
] as const;

export function checklistFor(type: CredentialingType): ChecklistDef[] {
  return type === "recred" ? RECRED_CHECKLIST : BASE_CHECKLIST;
}

export function mapChecklistDef(row: ChecklistDefRow) {
  return {
    id: row.id,
    key: row.item_key,
    label: row.label,
    scope: row.scope,
    credentialingType: row.credentialing_type,
    specialty: row.specialty,
    specialtyLabel: row.specialty ? SPECIALTIES[row.specialty] || row.specialty : null,
    packetId: row.packet_id,
    sortOrder: row.sort_order,
    active: !!row.active,
    createdAt: row.created_at,
  };
}

function slugKey(label: string): string {
  const base = label
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_|_$/g, "")
    .slice(0, 40);
  return base || `item_${crypto.randomUUID().slice(0, 8)}`;
}

export function makeItemKey(label: string): string {
  return slugKey(label);
}

/** Merge global + specialty (+ optional packet) defs; packet overrides specialty overrides global for same key. */
export async function resolveChecklistForPacket(
  env: Env,
  opts: {
    credentialingType: CredentialingType;
    specialty: string;
    packetId?: string | null;
  }
): Promise<ChecklistDef[]> {
  const rows = (
    await env.DB.prepare(
      `SELECT * FROM checklist_defs
       WHERE active = 1
         AND (
           (scope = 'global' AND (credentialing_type = 'both' OR credentialing_type = ?))
           OR (scope = 'specialty' AND specialty = ? AND (credentialing_type = 'both' OR credentialing_type = ?))
           OR (scope = 'packet' AND packet_id = ?)
         )
       ORDER BY
         CASE scope WHEN 'global' THEN 1 WHEN 'specialty' THEN 2 WHEN 'packet' THEN 3 ELSE 4 END,
         sort_order ASC,
         created_at ASC`
    )
      .bind(
        opts.credentialingType,
        opts.specialty,
        opts.credentialingType,
        opts.packetId || "__none__"
      )
      .all<ChecklistDefRow>()
  ).results;

  if (!rows.length) {
    return checklistFor(opts.credentialingType).map((c) => ({
      ...c,
      scope: "global" as ChecklistScope,
    }));
  }

  const byKey = new Map<string, ChecklistDef>();
  for (const row of rows) {
    byKey.set(row.item_key, {
      key: row.item_key,
      label: row.label,
      defId: row.id,
      scope: row.scope,
    });
  }
  return Array.from(byKey.values());
}

export async function listChecklistDefs(
  env: Env,
  opts?: { scope?: ChecklistScope; specialty?: string; packetId?: string }
) {
  let q = `SELECT * FROM checklist_defs WHERE active = 1`;
  const binds: string[] = [];
  if (opts?.scope) {
    q += ` AND scope = ?`;
    binds.push(opts.scope);
  }
  if (opts?.specialty) {
    q += ` AND specialty = ?`;
    binds.push(opts.specialty);
  }
  if (opts?.packetId) {
    q += ` AND packet_id = ?`;
    binds.push(opts.packetId);
  }
  q += ` ORDER BY scope ASC, credentialing_type ASC, specialty ASC, sort_order ASC, created_at ASC`;
  const stmt = env.DB.prepare(q);
  const rows = (
    binds.length ? await stmt.bind(...binds).all<ChecklistDefRow>() : await stmt.all<ChecklistDefRow>()
  ).results;
  return rows.map(mapChecklistDef);
}

export async function applyDefToMatchingPackets(
  env: Env,
  def: ChecklistDefRow
): Promise<number> {
  let packetsQ = `SELECT id, credentialing_type, specialty FROM packets WHERE status IN ('in_progress', 'query_pending', 'ready_for_review')`;
  const binds: string[] = [];

  if (def.scope === "packet") {
    if (!def.packet_id) return 0;
    packetsQ += ` AND id = ?`;
    binds.push(def.packet_id);
  } else if (def.scope === "specialty") {
    if (!def.specialty) return 0;
    packetsQ += ` AND specialty = ?`;
    binds.push(def.specialty);
  }

  if (def.credentialing_type !== "both") {
    packetsQ += ` AND credentialing_type = ?`;
    binds.push(def.credentialing_type);
  }

  const stmt = env.DB.prepare(packetsQ);
  const packets = (
    binds.length
      ? await stmt.bind(...binds).all<{ id: string; credentialing_type: string; specialty: string }>()
      : await stmt.all<{ id: string; credentialing_type: string; specialty: string }>()
  ).results;

  let added = 0;
  for (const p of packets) {
    const existing = await env.DB.prepare(
      `SELECT id FROM packet_items WHERE packet_id = ? AND item_key = ?`
    )
      .bind(p.id, def.item_key)
      .first();
    if (existing) continue;

    const maxSort = await env.DB.prepare(
      `SELECT COALESCE(MAX(sort_order), 0) AS m FROM packet_items WHERE packet_id = ?`
    )
      .bind(p.id)
      .first<{ m: number }>();

    await env.DB.prepare(
      `INSERT INTO packet_items
        (id, packet_id, item_key, label, sort_order, status, notes, source_scope, source_def_id)
       VALUES (?, ?, ?, ?, ?, 'pending', '', ?, ?)`
    )
      .bind(
        newId("item"),
        p.id,
        def.item_key,
        def.label,
        (maxSort?.m || 0) + 1,
        def.scope,
        def.id
      )
      .run();
    await env.DB.prepare(
      `UPDATE packets SET updated_at = datetime('now') WHERE id = ?`
    )
      .bind(p.id)
      .run();
    added += 1;
  }
  return added;
}
