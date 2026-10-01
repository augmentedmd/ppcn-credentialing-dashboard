-- Admin features: watcher role, email field, and specialties table
-- Note: SQLite CHECK constraints on existing tables cannot be modified without recreating the table
-- Since the application validates roles in code, we'll skip updating the CHECK constraint
-- and just add the email column and specialties table

-- Add email column to users table
-- Using a default value allows this to work on existing tables
ALTER TABLE users ADD COLUMN email TEXT DEFAULT '';

-- Create specialties table
CREATE TABLE IF NOT EXISTS specialties (
  id TEXT PRIMARY KEY,
  key TEXT NOT NULL UNIQUE,
  label TEXT NOT NULL,
  provider_type TEXT NOT NULL CHECK (provider_type IN ('surgeon', 'pa', 'anesthesia')),
  sort_order INTEGER NOT NULL DEFAULT 0,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_specialties_provider_type ON specialties(provider_type);
CREATE INDEX IF NOT EXISTS idx_specialties_active ON specialties(active);

-- Seed default specialties
INSERT OR IGNORE INTO specialties (id, key, label, provider_type, sort_order, active) VALUES
  ('spec_gen_surg', 'gen_surg', 'General Surgery', 'surgeon', 1, 1),
  ('spec_gi', 'gi', 'Gastroenterology', 'surgeon', 2, 1),
  ('spec_gyn', 'gyn', 'Gynecology', 'surgeon', 3, 1),
  ('spec_ent', 'ent', 'Otolaryngology', 'surgeon', 4, 1),
  ('spec_ortho', 'ortho', 'Orthopedic Surgery', 'surgeon', 5, 1),
  ('spec_ophthalmology', 'ophthalmology', 'Ophthalmology', 'surgeon', 6, 1),
  ('spec_plastic', 'plastic', 'Plastic Surgery', 'surgeon', 7, 1),
  ('spec_podiatry', 'podiatry', 'Podiatry', 'surgeon', 8, 1),
  ('spec_urology', 'urology', 'Urology', 'surgeon', 9, 1),
  ('spec_pain', 'pain', 'Pain Medicine', 'surgeon', 10, 1),
  ('spec_pa', 'pa', 'Physician Assistant', 'pa', 1, 1),
  ('spec_anesthesia_physician', 'anesthesia_physician', 'Anesthesiology — Physician (MD or DO)', 'anesthesia', 1, 1),
  ('spec_anesthesia_crna', 'anesthesia_crna', 'Anesthesiology — CRNA', 'anesthesia', 2, 1);
