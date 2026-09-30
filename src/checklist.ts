import type { ChecklistDef, CredentialingType } from "./types";

/** Core packet components from the PPCN Privileging Requirements Guide. */
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

/** Recredentialing focuses on privilege renewal documentation. */
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

export function newId(prefix: string): string {
  const rand = crypto.randomUUID().replace(/-/g, "").slice(0, 16);
  return `${prefix}_${rand}`;
}
