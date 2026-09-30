-- Demo credentialing packets across completeness / lifecycle stages.
-- Requires users from 0002_seed.sql. Safe to re-run (INSERT OR IGNORE).

-- ---------------------------------------------------------------------------
-- 1. Early collection — mostly pending (new surgeon, orthopedics)
-- ---------------------------------------------------------------------------
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_early',
  'Sarah Chen, MD',
  'surgeon',
  'ortho',
  'new',
  '["Orthopedic Surgery — Core Privileges","Fluoroscopy"]',
  'in_progress',
  'Demo: early packet — license and photo ID only so far.',
  'usr_admin',
  datetime('now', '-18 days'),
  datetime('now', '-2 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_early_01', 'pkt_demo_early', 'references', 'Three Professional References', 1, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_early_02', 'pkt_demo_early', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-16 days')),
  ('item_demo_early_03', 'pkt_demo_early', 'board_cert', 'Proof of Board Certification', 3, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_early_04', 'pkt_demo_early', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-15 days')),
  ('item_demo_early_05', 'pkt_demo_early', 'dea', 'DEA Certificate', 5, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_early_06', 'pkt_demo_early', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_early_07', 'pkt_demo_early', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_early_08', 'pkt_demo_early', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_early_09', 'pkt_demo_early', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_early_10', 'pkt_demo_early', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_early_11', 'pkt_demo_early', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_early_12', 'pkt_demo_early', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_early_13', 'pkt_demo_early', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_early_14', 'pkt_demo_early', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-18 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_early_ken', 'pkt_demo_early', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_early_gorin', 'pkt_demo_early', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_early_herman', 'pkt_demo_early', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_early_vijay', 'pkt_demo_early', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_early_stelios', 'pkt_demo_early', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- ---------------------------------------------------------------------------
-- 2. Mid collection — roughly half complete (new surgeon, GI)
-- ---------------------------------------------------------------------------
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_mid',
  'James Okonkwo, MD',
  'surgeon',
  'gi',
  'new',
  '["Gastroenterology — Core Privileges","Colonoscopy","EGD"]',
  'in_progress',
  'Demo: mid-packet — awaiting health forms and case log.',
  'usr_admin',
  datetime('now', '-25 days'),
  datetime('now', '-1 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_mid_01', 'pkt_demo_mid', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-20 days')),
  ('item_demo_mid_02', 'pkt_demo_mid', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-24 days')),
  ('item_demo_mid_03', 'pkt_demo_mid', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-18 days')),
  ('item_demo_mid_04', 'pkt_demo_mid', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-24 days')),
  ('item_demo_mid_05', 'pkt_demo_mid', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-22 days')),
  ('item_demo_mid_06', 'pkt_demo_mid', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-15 days')),
  ('item_demo_mid_07', 'pkt_demo_mid', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', 'Mount Sinai certificate on file', datetime('now', '-12 days')),
  ('item_demo_mid_08', 'pkt_demo_mid', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', 'Requested from provider', datetime('now', '-5 days')),
  ('item_demo_mid_09', 'pkt_demo_mid', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-25 days')),
  ('item_demo_mid_10', 'pkt_demo_mid', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-25 days')),
  ('item_demo_mid_11', 'pkt_demo_mid', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-25 days')),
  ('item_demo_mid_12', 'pkt_demo_mid', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_mid_13', 'pkt_demo_mid', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', 'Awaiting endoscopy log', datetime('now', '-3 days')),
  ('item_demo_mid_14', 'pkt_demo_mid', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'na', 'Not required for this privilege set', datetime('now', '-10 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_mid_ken', 'pkt_demo_mid', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_mid_gorin', 'pkt_demo_mid', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_mid_herman', 'pkt_demo_mid', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_mid_vijay', 'pkt_demo_mid', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_mid_stelios', 'pkt_demo_mid', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- ---------------------------------------------------------------------------
-- 3. Nearly complete — one item still pending (new PA)
-- ---------------------------------------------------------------------------
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_nearly',
  'Priya Patel, PA-C',
  'pa',
  'pa',
  'new',
  '["Physician Assistant — Core Privileges"]',
  'in_progress',
  'Demo: nearly complete — waiting on Quantiferon only.',
  'usr_admin',
  datetime('now', '-30 days'),
  datetime('now', '-6 hours')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_nearly_01', 'pkt_demo_nearly', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-28 days')),
  ('item_demo_nearly_02', 'pkt_demo_nearly', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-29 days')),
  ('item_demo_nearly_03', 'pkt_demo_nearly', 'board_cert', 'Proof of Board Certification', 3, 'complete', 'NCCPA on file', datetime('now', '-25 days')),
  ('item_demo_nearly_04', 'pkt_demo_nearly', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-29 days')),
  ('item_demo_nearly_05', 'pkt_demo_nearly', 'dea', 'DEA Certificate', 5, 'na', 'No controlled-substance privileges requested', datetime('now', '-20 days')),
  ('item_demo_nearly_06', 'pkt_demo_nearly', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-22 days')),
  ('item_demo_nearly_07', 'pkt_demo_nearly', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-18 days')),
  ('item_demo_nearly_08', 'pkt_demo_nearly', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_nearly_09', 'pkt_demo_nearly', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_nearly_10', 'pkt_demo_nearly', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', 'Lab draw scheduled', datetime('now', '-1 days')),
  ('item_demo_nearly_11', 'pkt_demo_nearly', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_nearly_12', 'pkt_demo_nearly', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_nearly_13', 'pkt_demo_nearly', 'case_log', 'Case Log (specialty template, when required)', 13, 'na', 'Not required for PA core privileges', datetime('now', '-8 days')),
  ('item_demo_nearly_14', 'pkt_demo_nearly', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'complete', 'BLS current', datetime('now', '-14 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_nearly_ken', 'pkt_demo_nearly', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_nearly_gorin', 'pkt_demo_nearly', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_nearly_herman', 'pkt_demo_nearly', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_nearly_vijay', 'pkt_demo_nearly', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_nearly_stelios', 'pkt_demo_nearly', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- ---------------------------------------------------------------------------
-- 4. Checklist done, not yet marked ready (new anesthesia MD)
-- ---------------------------------------------------------------------------
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_complete',
  'Amanda Brooks, MD',
  'anesthesia',
  'anesthesia_physician',
  'new',
  '["Anesthesiology — Physician Core Privileges"]',
  'in_progress',
  'Demo: all components complete/N/A — staff can mark Ready for Review.',
  'usr_admin',
  datetime('now', '-21 days'),
  datetime('now', '-3 hours')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_complete_01', 'pkt_demo_complete', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_complete_02', 'pkt_demo_complete', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-20 days')),
  ('item_demo_complete_03', 'pkt_demo_complete', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_complete_04', 'pkt_demo_complete', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-20 days')),
  ('item_demo_complete_05', 'pkt_demo_complete', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-18 days')),
  ('item_demo_complete_06', 'pkt_demo_complete', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-15 days')),
  ('item_demo_complete_07', 'pkt_demo_complete', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_complete_08', 'pkt_demo_complete', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_complete_09', 'pkt_demo_complete', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_complete_10', 'pkt_demo_complete', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_complete_11', 'pkt_demo_complete', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_complete_12', 'pkt_demo_complete', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'complete', '', datetime('now', '-2 days')),
  ('item_demo_complete_13', 'pkt_demo_complete', 'case_log', 'Case Log (specialty template, when required)', 13, 'na', 'Not required for anesthesia physician core', datetime('now', '-2 days')),
  ('item_demo_complete_14', 'pkt_demo_complete', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'complete', 'ACLS/BLS current', datetime('now', '-8 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_complete_ken', 'pkt_demo_complete', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_complete_gorin', 'pkt_demo_complete', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_complete_herman', 'pkt_demo_complete', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_complete_vijay', 'pkt_demo_complete', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_complete_stelios', 'pkt_demo_complete', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- ---------------------------------------------------------------------------
-- 5. Ready for review — partial board votes (new surgeon, gyn)
-- ---------------------------------------------------------------------------
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at, ready_at
) VALUES (
  'pkt_demo_ready',
  'Maria Santos, MD',
  'surgeon',
  'gyn',
  'new',
  '["Gynecology — Core Privileges","Hysteroscopy"]',
  'ready_for_review',
  'Demo: ready for governing board — two Yes votes cast so far.',
  'usr_admin',
  datetime('now', '-40 days'),
  datetime('now', '-1 days'),
  datetime('now', '-3 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_ready_01', 'pkt_demo_ready', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-20 days')),
  ('item_demo_ready_02', 'pkt_demo_ready', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-38 days')),
  ('item_demo_ready_03', 'pkt_demo_ready', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-30 days')),
  ('item_demo_ready_04', 'pkt_demo_ready', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-38 days')),
  ('item_demo_ready_05', 'pkt_demo_ready', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-35 days')),
  ('item_demo_ready_06', 'pkt_demo_ready', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-28 days')),
  ('item_demo_ready_07', 'pkt_demo_ready', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-25 days')),
  ('item_demo_ready_08', 'pkt_demo_ready', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_ready_09', 'pkt_demo_ready', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_ready_10', 'pkt_demo_ready', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_ready_11', 'pkt_demo_ready', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-14 days')),
  ('item_demo_ready_12', 'pkt_demo_ready', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_ready_13', 'pkt_demo_ready', 'case_log', 'Case Log (specialty template, when required)', 13, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_ready_14', 'pkt_demo_ready', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'na', '', datetime('now', '-8 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution, voted_at) VALUES
  ('vote_demo_ready_ken', 'pkt_demo_ready', 'usr_ken_long', 'Ken Long', 'yes', '', '', datetime('now', '-2 days')),
  ('vote_demo_ready_gorin', 'pkt_demo_ready', 'usr_michael_gorin', 'Michael Gorin', 'yes', '', '', datetime('now', '-1 days')),
  ('vote_demo_ready_herman', 'pkt_demo_ready', 'usr_michael_herman', 'Michael Herman', NULL, '', '', NULL),
  ('vote_demo_ready_vijay', 'pkt_demo_ready', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', '', NULL),
  ('vote_demo_ready_stelios', 'pkt_demo_ready', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '', NULL);

-- ---------------------------------------------------------------------------
-- 6. Query pending — pause for query on recredentialing ENT
-- ---------------------------------------------------------------------------
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at, ready_at
) VALUES (
  'pkt_demo_query',
  'Robert Walsh, MD',
  'surgeon',
  'ent',
  'recred',
  '["Otolaryngology — Core Privileges","Sinus Surgery"]',
  'query_pending',
  'Demo: board paused for query on case-log volume.',
  'usr_admin',
  datetime('now', '-55 days'),
  datetime('now', '-8 hours'),
  datetime('now', '-5 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_query_01', 'pkt_demo_query', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 1, 'complete', '', datetime('now', '-20 days')),
  ('item_demo_query_02', 'pkt_demo_query', 'case_log', 'Case Log meeting renewal volume requirements', 2, 'complete', 'Borderline volume for sinus privileges', datetime('now', '-15 days')),
  ('item_demo_query_03', 'pkt_demo_query', 'board_cert', 'Current Board Certification / MOC (as applicable)', 3, 'complete', '', datetime('now', '-30 days')),
  ('item_demo_query_04', 'pkt_demo_query', 'nys_license', 'Current New York State License Certificate', 4, 'complete', '', datetime('now', '-40 days')),
  ('item_demo_query_05', 'pkt_demo_query', 'dea', 'Current DEA Certificate (if applicable)', 5, 'complete', '', datetime('now', '-40 days')),
  ('item_demo_query_06', 'pkt_demo_query', 'malpractice', 'Current Proof of Professional Liability Coverage', 6, 'complete', '', datetime('now', '-25 days')),
  ('item_demo_query_07', 'pkt_demo_query', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 7, 'complete', '', datetime('now', '-18 days')),
  ('item_demo_query_08', 'pkt_demo_query', 'physical_exam', 'Physical Examination Form', 8, 'complete', '', datetime('now', '-18 days')),
  ('item_demo_query_09', 'pkt_demo_query', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 9, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_query_10', 'pkt_demo_query', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 10, 'complete', '', datetime('now', '-18 days')),
  ('item_demo_query_11', 'pkt_demo_query', 'training_certs', 'Renewal training certificates if applicable (Fluoroscopy, Laser/Fire Safety, Chemo Admin, ACLS/BLS)', 11, 'na', '', datetime('now', '-20 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution, voted_at) VALUES
  ('vote_demo_query_ken', 'pkt_demo_query', 'usr_ken_long', 'Ken Long', 'yes', '', '', datetime('now', '-4 days')),
  ('vote_demo_query_gorin', 'pkt_demo_query', 'usr_michael_gorin', 'Michael Gorin', 'pause_for_query', 'Please clarify whether sinus case volume meets renewal thresholds for the requested privilege block.', '', datetime('now', '-8 hours')),
  ('vote_demo_query_herman', 'pkt_demo_query', 'usr_michael_herman', 'Michael Herman', 'yes', '', '', datetime('now', '-3 days')),
  ('vote_demo_query_vijay', 'pkt_demo_query', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', '', NULL),
  ('vote_demo_query_stelios', 'pkt_demo_query', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '', NULL);

-- ---------------------------------------------------------------------------
-- 7. Approved — full Yes from board (recredentialing ophthalmology)
-- ---------------------------------------------------------------------------
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at, ready_at, closed_at
) VALUES (
  'pkt_demo_approved',
  'Elena Vasquez, MD',
  'surgeon',
  'ophthalmology',
  'recred',
  '["Ophthalmology — Core Privileges","Cataract Surgery"]',
  'approved',
  'Demo: approved by unanimous Yes votes.',
  'usr_admin',
  datetime('now', '-90 days'),
  datetime('now', '-14 days'),
  datetime('now', '-21 days'),
  datetime('now', '-14 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_approved_01', 'pkt_demo_approved', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 1, 'complete', '', datetime('now', '-40 days')),
  ('item_demo_approved_02', 'pkt_demo_approved', 'case_log', 'Case Log meeting renewal volume requirements', 2, 'complete', '', datetime('now', '-35 days')),
  ('item_demo_approved_03', 'pkt_demo_approved', 'board_cert', 'Current Board Certification / MOC (as applicable)', 3, 'complete', '', datetime('now', '-50 days')),
  ('item_demo_approved_04', 'pkt_demo_approved', 'nys_license', 'Current New York State License Certificate', 4, 'complete', '', datetime('now', '-60 days')),
  ('item_demo_approved_05', 'pkt_demo_approved', 'dea', 'Current DEA Certificate (if applicable)', 5, 'na', 'Not applicable', datetime('now', '-50 days')),
  ('item_demo_approved_06', 'pkt_demo_approved', 'malpractice', 'Current Proof of Professional Liability Coverage', 6, 'complete', '', datetime('now', '-45 days')),
  ('item_demo_approved_07', 'pkt_demo_approved', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 7, 'complete', '', datetime('now', '-30 days')),
  ('item_demo_approved_08', 'pkt_demo_approved', 'physical_exam', 'Physical Examination Form', 8, 'complete', '', datetime('now', '-30 days')),
  ('item_demo_approved_09', 'pkt_demo_approved', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 9, 'complete', '', datetime('now', '-28 days')),
  ('item_demo_approved_10', 'pkt_demo_approved', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 10, 'complete', '', datetime('now', '-30 days')),
  ('item_demo_approved_11', 'pkt_demo_approved', 'training_certs', 'Renewal training certificates if applicable (Fluoroscopy, Laser/Fire Safety, Chemo Admin, ACLS/BLS)', 11, 'complete', 'Laser safety current', datetime('now', '-32 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution, voted_at) VALUES
  ('vote_demo_approved_ken', 'pkt_demo_approved', 'usr_ken_long', 'Ken Long', 'yes', '', '', datetime('now', '-18 days')),
  ('vote_demo_approved_gorin', 'pkt_demo_approved', 'usr_michael_gorin', 'Michael Gorin', 'yes', '', '', datetime('now', '-17 days')),
  ('vote_demo_approved_herman', 'pkt_demo_approved', 'usr_michael_herman', 'Michael Herman', 'yes', '', '', datetime('now', '-16 days')),
  ('vote_demo_approved_vijay', 'pkt_demo_approved', 'usr_vijay_mukhija', 'Vijay Mukhija', 'yes', '', '', datetime('now', '-15 days')),
  ('vote_demo_approved_stelios', 'pkt_demo_approved', 'usr_stelios', 'Stelios Koutsoumbelis', 'yes', '', '', datetime('now', '-14 days'));

-- ---------------------------------------------------------------------------
-- 8. Denied — board No vote (new CRNA)
-- ---------------------------------------------------------------------------
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at, ready_at, closed_at
) VALUES (
  'pkt_demo_denied',
  'Thomas Nguyen, CRNA',
  'anesthesia',
  'anesthesia_crna',
  'new',
  '["Anesthesiology — CRNA Core Privileges"]',
  'denied',
  'Demo: denied after a No vote on incomplete reference verification.',
  'usr_admin',
  datetime('now', '-70 days'),
  datetime('now', '-20 days'),
  datetime('now', '-28 days'),
  datetime('now', '-20 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_denied_01', 'pkt_demo_denied', 'references', 'Three Professional References', 1, 'complete', 'One reference returned incomplete details', datetime('now', '-40 days')),
  ('item_demo_denied_02', 'pkt_demo_denied', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-65 days')),
  ('item_demo_denied_03', 'pkt_demo_denied', 'board_cert', 'Proof of Board Certification', 3, 'complete', 'NBCRNA on file', datetime('now', '-50 days')),
  ('item_demo_denied_04', 'pkt_demo_denied', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-65 days')),
  ('item_demo_denied_05', 'pkt_demo_denied', 'dea', 'DEA Certificate', 5, 'na', '', datetime('now', '-55 days')),
  ('item_demo_denied_06', 'pkt_demo_denied', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-48 days')),
  ('item_demo_denied_07', 'pkt_demo_denied', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-45 days')),
  ('item_demo_denied_08', 'pkt_demo_denied', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-35 days')),
  ('item_demo_denied_09', 'pkt_demo_denied', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-35 days')),
  ('item_demo_denied_10', 'pkt_demo_denied', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-33 days')),
  ('item_demo_denied_11', 'pkt_demo_denied', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-35 days')),
  ('item_demo_denied_12', 'pkt_demo_denied', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'complete', '', datetime('now', '-32 days')),
  ('item_demo_denied_13', 'pkt_demo_denied', 'case_log', 'Case Log (specialty template, when required)', 13, 'na', '', datetime('now', '-32 days')),
  ('item_demo_denied_14', 'pkt_demo_denied', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'complete', 'ACLS/BLS current', datetime('now', '-40 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution, voted_at) VALUES
  ('vote_demo_denied_ken', 'pkt_demo_denied', 'usr_ken_long', 'Ken Long', 'yes', '', '', datetime('now', '-25 days')),
  ('vote_demo_denied_gorin', 'pkt_demo_denied', 'usr_michael_gorin', 'Michael Gorin', 'no', '', '', datetime('now', '-22 days')),
  ('vote_demo_denied_herman', 'pkt_demo_denied', 'usr_michael_herman', 'Michael Herman', 'yes', '', '', datetime('now', '-24 days')),
  ('vote_demo_denied_vijay', 'pkt_demo_denied', 'usr_vijay_mukhija', 'Vijay Mukhija', 'yes', '', '', datetime('now', '-21 days')),
  ('vote_demo_denied_stelios', 'pkt_demo_denied', 'usr_stelios', 'Stelios Koutsoumbelis', 'yes', '', '', datetime('now', '-20 days'));

-- ---------------------------------------------------------------------------
-- 9. Fresh blank packet — brand-new application, nothing collected yet
-- ---------------------------------------------------------------------------
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_blank',
  'Kevin Morales, DPM',
  'surgeon',
  'podiatry',
  'new',
  '["Podiatry — Core Privileges"]',
  'in_progress',
  'Demo: newly opened packet — no components collected yet.',
  'usr_admin',
  datetime('now', '-1 days'),
  datetime('now', '-1 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_blank_01', 'pkt_demo_blank', 'references', 'Three Professional References', 1, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_02', 'pkt_demo_blank', 'photo_id', 'Government-issued Photo ID', 2, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_03', 'pkt_demo_blank', 'board_cert', 'Proof of Board Certification', 3, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_04', 'pkt_demo_blank', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_05', 'pkt_demo_blank', 'dea', 'DEA Certificate', 5, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_06', 'pkt_demo_blank', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_07', 'pkt_demo_blank', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_08', 'pkt_demo_blank', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_09', 'pkt_demo_blank', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_10', 'pkt_demo_blank', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_11', 'pkt_demo_blank', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_12', 'pkt_demo_blank', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_13', 'pkt_demo_blank', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_blank_14', 'pkt_demo_blank', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_blank_ken', 'pkt_demo_blank', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_blank_gorin', 'pkt_demo_blank', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_blank_herman', 'pkt_demo_blank', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_blank_vijay', 'pkt_demo_blank', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_blank_stelios', 'pkt_demo_blank', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');
