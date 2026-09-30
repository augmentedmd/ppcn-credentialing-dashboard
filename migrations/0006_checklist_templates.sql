-- Configurable checklist templates (global / specialty / per-packet)
-- plus source tracking on packet_items.

CREATE TABLE IF NOT EXISTS checklist_defs (
  id TEXT PRIMARY KEY,
  item_key TEXT NOT NULL,
  label TEXT NOT NULL,
  scope TEXT NOT NULL CHECK (scope IN ('global', 'specialty', 'packet')),
  credentialing_type TEXT NOT NULL DEFAULT 'both'
    CHECK (credentialing_type IN ('new', 'recred', 'both')),
  specialty TEXT,
  packet_id TEXT REFERENCES packets(id) ON DELETE CASCADE,
  sort_order INTEGER NOT NULL DEFAULT 0,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_checklist_defs_scope ON checklist_defs(scope, active);
CREATE INDEX IF NOT EXISTS idx_checklist_defs_specialty ON checklist_defs(specialty, active);
CREATE INDEX IF NOT EXISTS idx_checklist_defs_packet ON checklist_defs(packet_id, active);

-- Track where each packet item came from (template vs one-off).
-- SQLite: ADD COLUMN is idempotent-safe only if not re-run; IF NOT EXISTS unsupported on older SQLite —
-- Wrangler D1 supports plain ADD COLUMN; re-running may error, so migrate scripts run once.

ALTER TABLE packet_items ADD COLUMN source_scope TEXT NOT NULL DEFAULT 'global';
ALTER TABLE packet_items ADD COLUMN source_def_id TEXT;

-- Seed global templates from the original hard-coded checklists (new credentialing).
INSERT OR IGNORE INTO checklist_defs (id, item_key, label, scope, credentialing_type, specialty, packet_id, sort_order, active) VALUES
  ('cdef_new_references', 'references', 'Three Professional References', 'global', 'new', NULL, NULL, 1, 1),
  ('cdef_new_photo_id', 'photo_id', 'Government-issued Photo ID', 'global', 'new', NULL, NULL, 2, 1),
  ('cdef_new_board_cert', 'board_cert', 'Proof of Board Certification', 'global', 'new', NULL, NULL, 3, 1),
  ('cdef_new_nys_license', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 'global', 'new', NULL, NULL, 4, 1),
  ('cdef_new_dea', 'dea', 'DEA Certificate', 'global', 'new', NULL, NULL, 5, 1),
  ('cdef_new_mandated_reporter', 'mandated_reporter', 'Mandated Reporter Training Certificate', 'global', 'new', NULL, NULL, 6, 1),
  ('cdef_new_malpractice', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 'global', 'new', NULL, NULL, 7, 1),
  ('cdef_new_health_assessment', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 'global', 'new', NULL, NULL, 8, 1),
  ('cdef_new_physical_exam', 'physical_exam', 'Physical Examination Form', 'global', 'new', NULL, NULL, 9, 1),
  ('cdef_new_quantiferon', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 'global', 'new', NULL, NULL, 10, 1),
  ('cdef_new_immunizations', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 'global', 'new', NULL, NULL, 11, 1),
  ('cdef_new_dop_form', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 'global', 'new', NULL, NULL, 12, 1),
  ('cdef_new_case_log', 'case_log', 'Case Log (specialty template, when required)', 'global', 'new', NULL, NULL, 13, 1),
  ('cdef_new_training_certs', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 'global', 'new', NULL, NULL, 14, 1);

INSERT OR IGNORE INTO checklist_defs (id, item_key, label, scope, credentialing_type, specialty, packet_id, sort_order, active) VALUES
  ('cdef_recred_dop_form', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 'global', 'recred', NULL, NULL, 1, 1),
  ('cdef_recred_case_log', 'case_log', 'Case Log meeting renewal volume requirements', 'global', 'recred', NULL, NULL, 2, 1),
  ('cdef_recred_board_cert', 'board_cert', 'Current Board Certification / MOC (as applicable)', 'global', 'recred', NULL, NULL, 3, 1),
  ('cdef_recred_nys_license', 'nys_license', 'Current New York State License Certificate', 'global', 'recred', NULL, NULL, 4, 1),
  ('cdef_recred_dea', 'dea', 'Current DEA Certificate (if applicable)', 'global', 'recred', NULL, NULL, 5, 1),
  ('cdef_recred_malpractice', 'malpractice', 'Current Proof of Professional Liability Coverage', 'global', 'recred', NULL, NULL, 6, 1),
  ('cdef_recred_health_assessment', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 'global', 'recred', NULL, NULL, 7, 1),
  ('cdef_recred_physical_exam', 'physical_exam', 'Physical Examination Form', 'global', 'recred', NULL, NULL, 8, 1),
  ('cdef_recred_quantiferon', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 'global', 'recred', NULL, NULL, 9, 1),
  ('cdef_recred_immunizations', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 'global', 'recred', NULL, NULL, 10, 1),
  ('cdef_recred_training_certs', 'training_certs', 'Renewal training certificates if applicable (Fluoroscopy, Laser/Fire Safety, Chemo Admin, ACLS/BLS)', 'global', 'recred', NULL, NULL, 11, 1);
