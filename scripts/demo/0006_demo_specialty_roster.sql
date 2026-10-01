-- Additional demo packets: 2–3 providers per specialty.
-- Complements 0003_demo_packets.sql. Safe to re-run (INSERT OR IGNORE).
-- Packet notes and item notes intentionally left blank.

-- General Surgery: Daniel Reeves, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec01',
  'Daniel Reeves, MD',
  'surgeon',
  'gen_surg',
  'new',
  '["General Surgery — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-6 days'),
  datetime('now', '-2 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec01_01', 'pkt_demo_spec01', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec01_02', 'pkt_demo_spec01', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec01_03', 'pkt_demo_spec01', 'board_cert', 'Proof of Board Certification', 3, 'pending', '', datetime('now', '-3 days')),
  ('item_demo_spec01_04', 'pkt_demo_spec01', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'pending', '', datetime('now', '-2 days')),
  ('item_demo_spec01_05', 'pkt_demo_spec01', 'dea', 'DEA Certificate', 5, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec01_06', 'pkt_demo_spec01', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec01_07', 'pkt_demo_spec01', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec01_08', 'pkt_demo_spec01', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec01_09', 'pkt_demo_spec01', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec01_10', 'pkt_demo_spec01', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec01_11', 'pkt_demo_spec01', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec01_12', 'pkt_demo_spec01', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec01_13', 'pkt_demo_spec01', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec01_14', 'pkt_demo_spec01', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec01_1', 'pkt_demo_spec01', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec01_2', 'pkt_demo_spec01', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec01_3', 'pkt_demo_spec01', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec01_4', 'pkt_demo_spec01', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec01_5', 'pkt_demo_spec01', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- General Surgery: Laura Kim, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec02',
  'Laura Kim, MD',
  'surgeon',
  'gen_surg',
  'new',
  '["General Surgery — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-7 days'),
  datetime('now', '-3 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec02_01', 'pkt_demo_spec02', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec02_02', 'pkt_demo_spec02', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec02_03', 'pkt_demo_spec02', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec02_04', 'pkt_demo_spec02', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec02_05', 'pkt_demo_spec02', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-2 days')),
  ('item_demo_spec02_06', 'pkt_demo_spec02', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec02_07', 'pkt_demo_spec02', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec02_08', 'pkt_demo_spec02', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec02_09', 'pkt_demo_spec02', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec02_10', 'pkt_demo_spec02', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec02_11', 'pkt_demo_spec02', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec02_12', 'pkt_demo_spec02', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec02_13', 'pkt_demo_spec02', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec02_14', 'pkt_demo_spec02', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec02_1', 'pkt_demo_spec02', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec02_2', 'pkt_demo_spec02', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec02_3', 'pkt_demo_spec02', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec02_4', 'pkt_demo_spec02', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec02_5', 'pkt_demo_spec02', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- General Surgery: Marcus Allen, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec03',
  'Marcus Allen, MD',
  'surgeon',
  'gen_surg',
  'recred',
  '["General Surgery — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-8 days'),
  datetime('now', '-4 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec03_01', 'pkt_demo_spec03', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec03_02', 'pkt_demo_spec03', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec03_03', 'pkt_demo_spec03', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec03_04', 'pkt_demo_spec03', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec03_05', 'pkt_demo_spec03', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec03_06', 'pkt_demo_spec03', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-2 days')),
  ('item_demo_spec03_07', 'pkt_demo_spec03', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec03_08', 'pkt_demo_spec03', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec03_09', 'pkt_demo_spec03', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec03_10', 'pkt_demo_spec03', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec03_11', 'pkt_demo_spec03', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec03_12', 'pkt_demo_spec03', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec03_13', 'pkt_demo_spec03', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec03_14', 'pkt_demo_spec03', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec03_1', 'pkt_demo_spec03', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec03_2', 'pkt_demo_spec03', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec03_3', 'pkt_demo_spec03', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec03_4', 'pkt_demo_spec03', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec03_5', 'pkt_demo_spec03', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Gastroenterology: Nina Patel, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec04',
  'Nina Patel, MD',
  'surgeon',
  'gi',
  'new',
  '["Gastroenterology — Core Privileges","Colonoscopy"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-9 days'),
  datetime('now', '-1 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec04_01', 'pkt_demo_spec04', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec04_02', 'pkt_demo_spec04', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec04_03', 'pkt_demo_spec04', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec04_04', 'pkt_demo_spec04', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec04_05', 'pkt_demo_spec04', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec04_06', 'pkt_demo_spec04', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec04_07', 'pkt_demo_spec04', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-2 days')),
  ('item_demo_spec04_08', 'pkt_demo_spec04', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec04_09', 'pkt_demo_spec04', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec04_10', 'pkt_demo_spec04', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec04_11', 'pkt_demo_spec04', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec04_12', 'pkt_demo_spec04', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec04_13', 'pkt_demo_spec04', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec04_14', 'pkt_demo_spec04', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec04_1', 'pkt_demo_spec04', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec04_2', 'pkt_demo_spec04', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec04_3', 'pkt_demo_spec04', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec04_4', 'pkt_demo_spec04', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec04_5', 'pkt_demo_spec04', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Gastroenterology: Christopher Shaw, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec05',
  'Christopher Shaw, MD',
  'surgeon',
  'gi',
  'new',
  '["Gastroenterology — Core Privileges","Colonoscopy"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-10 days'),
  datetime('now', '-2 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec05_01', 'pkt_demo_spec05', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec05_02', 'pkt_demo_spec05', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec05_03', 'pkt_demo_spec05', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec05_04', 'pkt_demo_spec05', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec05_05', 'pkt_demo_spec05', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec05_06', 'pkt_demo_spec05', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec05_07', 'pkt_demo_spec05', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec05_08', 'pkt_demo_spec05', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-2 days')),
  ('item_demo_spec05_09', 'pkt_demo_spec05', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec05_10', 'pkt_demo_spec05', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec05_11', 'pkt_demo_spec05', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec05_12', 'pkt_demo_spec05', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec05_13', 'pkt_demo_spec05', 'case_log', 'Case Log (specialty template, when required)', 13, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec05_14', 'pkt_demo_spec05', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'na', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec05_1', 'pkt_demo_spec05', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec05_2', 'pkt_demo_spec05', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec05_3', 'pkt_demo_spec05', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec05_4', 'pkt_demo_spec05', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec05_5', 'pkt_demo_spec05', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Gynecology: Aisha Rahman, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec06',
  'Aisha Rahman, MD',
  'surgeon',
  'gyn',
  'recred',
  '["Gynecology — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-11 days'),
  datetime('now', '-3 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec06_01', 'pkt_demo_spec06', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec06_02', 'pkt_demo_spec06', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec06_03', 'pkt_demo_spec06', 'board_cert', 'Proof of Board Certification', 3, 'pending', '', datetime('now', '-8 days')),
  ('item_demo_spec06_04', 'pkt_demo_spec06', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'pending', '', datetime('now', '-7 days')),
  ('item_demo_spec06_05', 'pkt_demo_spec06', 'dea', 'DEA Certificate', 5, 'pending', '', datetime('now', '-6 days')),
  ('item_demo_spec06_06', 'pkt_demo_spec06', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-5 days')),
  ('item_demo_spec06_07', 'pkt_demo_spec06', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-4 days')),
  ('item_demo_spec06_08', 'pkt_demo_spec06', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-3 days')),
  ('item_demo_spec06_09', 'pkt_demo_spec06', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-2 days')),
  ('item_demo_spec06_10', 'pkt_demo_spec06', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec06_11', 'pkt_demo_spec06', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec06_12', 'pkt_demo_spec06', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec06_13', 'pkt_demo_spec06', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec06_14', 'pkt_demo_spec06', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec06_1', 'pkt_demo_spec06', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec06_2', 'pkt_demo_spec06', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec06_3', 'pkt_demo_spec06', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec06_4', 'pkt_demo_spec06', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec06_5', 'pkt_demo_spec06', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Gynecology: Brian Foster, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec07',
  'Brian Foster, MD',
  'surgeon',
  'gyn',
  'new',
  '["Gynecology — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-12 days'),
  datetime('now', '-4 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec07_01', 'pkt_demo_spec07', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-11 days')),
  ('item_demo_spec07_02', 'pkt_demo_spec07', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec07_03', 'pkt_demo_spec07', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec07_04', 'pkt_demo_spec07', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec07_05', 'pkt_demo_spec07', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec07_06', 'pkt_demo_spec07', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-6 days')),
  ('item_demo_spec07_07', 'pkt_demo_spec07', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-5 days')),
  ('item_demo_spec07_08', 'pkt_demo_spec07', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-4 days')),
  ('item_demo_spec07_09', 'pkt_demo_spec07', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-3 days')),
  ('item_demo_spec07_10', 'pkt_demo_spec07', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-2 days')),
  ('item_demo_spec07_11', 'pkt_demo_spec07', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec07_12', 'pkt_demo_spec07', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec07_13', 'pkt_demo_spec07', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec07_14', 'pkt_demo_spec07', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec07_1', 'pkt_demo_spec07', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec07_2', 'pkt_demo_spec07', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec07_3', 'pkt_demo_spec07', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec07_4', 'pkt_demo_spec07', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec07_5', 'pkt_demo_spec07', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Otolaryngology: Helen Cho, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec08',
  'Helen Cho, MD',
  'surgeon',
  'ent',
  'new',
  '["Otolaryngology — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-13 days'),
  datetime('now', '-1 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec08_01', 'pkt_demo_spec08', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_spec08_02', 'pkt_demo_spec08', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-11 days')),
  ('item_demo_spec08_03', 'pkt_demo_spec08', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec08_04', 'pkt_demo_spec08', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec08_05', 'pkt_demo_spec08', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec08_06', 'pkt_demo_spec08', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec08_07', 'pkt_demo_spec08', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec08_08', 'pkt_demo_spec08', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec08_09', 'pkt_demo_spec08', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-4 days')),
  ('item_demo_spec08_10', 'pkt_demo_spec08', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-3 days')),
  ('item_demo_spec08_11', 'pkt_demo_spec08', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-2 days')),
  ('item_demo_spec08_12', 'pkt_demo_spec08', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec08_13', 'pkt_demo_spec08', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec08_14', 'pkt_demo_spec08', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec08_1', 'pkt_demo_spec08', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec08_2', 'pkt_demo_spec08', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec08_3', 'pkt_demo_spec08', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec08_4', 'pkt_demo_spec08', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec08_5', 'pkt_demo_spec08', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Otolaryngology: Peter Lang, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec09',
  'Peter Lang, MD',
  'surgeon',
  'ent',
  'recred',
  '["Otolaryngology — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-14 days'),
  datetime('now', '-2 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec09_01', 'pkt_demo_spec09', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-13 days')),
  ('item_demo_spec09_02', 'pkt_demo_spec09', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_spec09_03', 'pkt_demo_spec09', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-11 days')),
  ('item_demo_spec09_04', 'pkt_demo_spec09', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec09_05', 'pkt_demo_spec09', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec09_06', 'pkt_demo_spec09', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec09_07', 'pkt_demo_spec09', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec09_08', 'pkt_demo_spec09', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec09_09', 'pkt_demo_spec09', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec09_10', 'pkt_demo_spec09', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec09_11', 'pkt_demo_spec09', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec09_12', 'pkt_demo_spec09', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-2 days')),
  ('item_demo_spec09_13', 'pkt_demo_spec09', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec09_14', 'pkt_demo_spec09', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec09_1', 'pkt_demo_spec09', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec09_2', 'pkt_demo_spec09', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec09_3', 'pkt_demo_spec09', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec09_4', 'pkt_demo_spec09', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec09_5', 'pkt_demo_spec09', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Orthopedic Surgery: Michael Torres, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec10',
  'Michael Torres, MD',
  'surgeon',
  'ortho',
  'new',
  '["Orthopedic Surgery — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-15 days'),
  datetime('now', '-3 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec10_01', 'pkt_demo_spec10', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-14 days')),
  ('item_demo_spec10_02', 'pkt_demo_spec10', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-13 days')),
  ('item_demo_spec10_03', 'pkt_demo_spec10', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_spec10_04', 'pkt_demo_spec10', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-11 days')),
  ('item_demo_spec10_05', 'pkt_demo_spec10', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec10_06', 'pkt_demo_spec10', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec10_07', 'pkt_demo_spec10', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec10_08', 'pkt_demo_spec10', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec10_09', 'pkt_demo_spec10', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec10_10', 'pkt_demo_spec10', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec10_11', 'pkt_demo_spec10', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec10_12', 'pkt_demo_spec10', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec10_13', 'pkt_demo_spec10', 'case_log', 'Case Log (specialty template, when required)', 13, 'complete', '', datetime('now', '-2 days')),
  ('item_demo_spec10_14', 'pkt_demo_spec10', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'na', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec10_1', 'pkt_demo_spec10', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec10_2', 'pkt_demo_spec10', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec10_3', 'pkt_demo_spec10', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec10_4', 'pkt_demo_spec10', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec10_5', 'pkt_demo_spec10', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Orthopedic Surgery: Rachel Green, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec11',
  'Rachel Green, MD',
  'surgeon',
  'ortho',
  'new',
  '["Orthopedic Surgery — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-16 days'),
  datetime('now', '-4 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec11_01', 'pkt_demo_spec11', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-15 days')),
  ('item_demo_spec11_02', 'pkt_demo_spec11', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-14 days')),
  ('item_demo_spec11_03', 'pkt_demo_spec11', 'board_cert', 'Proof of Board Certification', 3, 'pending', '', datetime('now', '-13 days')),
  ('item_demo_spec11_04', 'pkt_demo_spec11', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'pending', '', datetime('now', '-12 days')),
  ('item_demo_spec11_05', 'pkt_demo_spec11', 'dea', 'DEA Certificate', 5, 'pending', '', datetime('now', '-11 days')),
  ('item_demo_spec11_06', 'pkt_demo_spec11', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-10 days')),
  ('item_demo_spec11_07', 'pkt_demo_spec11', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-9 days')),
  ('item_demo_spec11_08', 'pkt_demo_spec11', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-8 days')),
  ('item_demo_spec11_09', 'pkt_demo_spec11', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-7 days')),
  ('item_demo_spec11_10', 'pkt_demo_spec11', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-6 days')),
  ('item_demo_spec11_11', 'pkt_demo_spec11', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-5 days')),
  ('item_demo_spec11_12', 'pkt_demo_spec11', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-4 days')),
  ('item_demo_spec11_13', 'pkt_demo_spec11', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-3 days')),
  ('item_demo_spec11_14', 'pkt_demo_spec11', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-2 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec11_1', 'pkt_demo_spec11', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec11_2', 'pkt_demo_spec11', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec11_3', 'pkt_demo_spec11', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec11_4', 'pkt_demo_spec11', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec11_5', 'pkt_demo_spec11', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Ophthalmology: Steven Park, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec12',
  'Steven Park, MD',
  'surgeon',
  'ophthalmology',
  'recred',
  '["Ophthalmology — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-17 days'),
  datetime('now', '-1 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec12_01', 'pkt_demo_spec12', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-16 days')),
  ('item_demo_spec12_02', 'pkt_demo_spec12', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-15 days')),
  ('item_demo_spec12_03', 'pkt_demo_spec12', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-14 days')),
  ('item_demo_spec12_04', 'pkt_demo_spec12', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-13 days')),
  ('item_demo_spec12_05', 'pkt_demo_spec12', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_spec12_06', 'pkt_demo_spec12', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-11 days')),
  ('item_demo_spec12_07', 'pkt_demo_spec12', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-10 days')),
  ('item_demo_spec12_08', 'pkt_demo_spec12', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-9 days')),
  ('item_demo_spec12_09', 'pkt_demo_spec12', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-8 days')),
  ('item_demo_spec12_10', 'pkt_demo_spec12', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-7 days')),
  ('item_demo_spec12_11', 'pkt_demo_spec12', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-6 days')),
  ('item_demo_spec12_12', 'pkt_demo_spec12', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-5 days')),
  ('item_demo_spec12_13', 'pkt_demo_spec12', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-4 days')),
  ('item_demo_spec12_14', 'pkt_demo_spec12', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-3 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec12_1', 'pkt_demo_spec12', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec12_2', 'pkt_demo_spec12', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec12_3', 'pkt_demo_spec12', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec12_4', 'pkt_demo_spec12', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec12_5', 'pkt_demo_spec12', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Ophthalmology: Olivia Grant, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec13',
  'Olivia Grant, MD',
  'surgeon',
  'ophthalmology',
  'new',
  '["Ophthalmology — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-18 days'),
  datetime('now', '-2 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec13_01', 'pkt_demo_spec13', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-17 days')),
  ('item_demo_spec13_02', 'pkt_demo_spec13', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-16 days')),
  ('item_demo_spec13_03', 'pkt_demo_spec13', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-15 days')),
  ('item_demo_spec13_04', 'pkt_demo_spec13', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-14 days')),
  ('item_demo_spec13_05', 'pkt_demo_spec13', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-13 days')),
  ('item_demo_spec13_06', 'pkt_demo_spec13', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_spec13_07', 'pkt_demo_spec13', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-11 days')),
  ('item_demo_spec13_08', 'pkt_demo_spec13', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec13_09', 'pkt_demo_spec13', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-9 days')),
  ('item_demo_spec13_10', 'pkt_demo_spec13', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-8 days')),
  ('item_demo_spec13_11', 'pkt_demo_spec13', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-7 days')),
  ('item_demo_spec13_12', 'pkt_demo_spec13', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-6 days')),
  ('item_demo_spec13_13', 'pkt_demo_spec13', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-5 days')),
  ('item_demo_spec13_14', 'pkt_demo_spec13', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-4 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec13_1', 'pkt_demo_spec13', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec13_2', 'pkt_demo_spec13', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec13_3', 'pkt_demo_spec13', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec13_4', 'pkt_demo_spec13', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec13_5', 'pkt_demo_spec13', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Plastic Surgery: Claire Bennett, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec14',
  'Claire Bennett, MD',
  'surgeon',
  'plastic',
  'new',
  '["Plastic Surgery — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-19 days'),
  datetime('now', '-3 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec14_01', 'pkt_demo_spec14', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-18 days')),
  ('item_demo_spec14_02', 'pkt_demo_spec14', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-17 days')),
  ('item_demo_spec14_03', 'pkt_demo_spec14', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-16 days')),
  ('item_demo_spec14_04', 'pkt_demo_spec14', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-15 days')),
  ('item_demo_spec14_05', 'pkt_demo_spec14', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-14 days')),
  ('item_demo_spec14_06', 'pkt_demo_spec14', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-13 days')),
  ('item_demo_spec14_07', 'pkt_demo_spec14', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_spec14_08', 'pkt_demo_spec14', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-11 days')),
  ('item_demo_spec14_09', 'pkt_demo_spec14', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec14_10', 'pkt_demo_spec14', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec14_11', 'pkt_demo_spec14', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec14_12', 'pkt_demo_spec14', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-7 days')),
  ('item_demo_spec14_13', 'pkt_demo_spec14', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-6 days')),
  ('item_demo_spec14_14', 'pkt_demo_spec14', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-5 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec14_1', 'pkt_demo_spec14', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec14_2', 'pkt_demo_spec14', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec14_3', 'pkt_demo_spec14', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec14_4', 'pkt_demo_spec14', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec14_5', 'pkt_demo_spec14', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Plastic Surgery: Anthony Ruiz, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec15',
  'Anthony Ruiz, MD',
  'surgeon',
  'plastic',
  'recred',
  '["Plastic Surgery — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-20 days'),
  datetime('now', '-4 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec15_01', 'pkt_demo_spec15', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-19 days')),
  ('item_demo_spec15_02', 'pkt_demo_spec15', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-18 days')),
  ('item_demo_spec15_03', 'pkt_demo_spec15', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-17 days')),
  ('item_demo_spec15_04', 'pkt_demo_spec15', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-16 days')),
  ('item_demo_spec15_05', 'pkt_demo_spec15', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-15 days')),
  ('item_demo_spec15_06', 'pkt_demo_spec15', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-14 days')),
  ('item_demo_spec15_07', 'pkt_demo_spec15', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-13 days')),
  ('item_demo_spec15_08', 'pkt_demo_spec15', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_spec15_09', 'pkt_demo_spec15', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-11 days')),
  ('item_demo_spec15_10', 'pkt_demo_spec15', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec15_11', 'pkt_demo_spec15', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec15_12', 'pkt_demo_spec15', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec15_13', 'pkt_demo_spec15', 'case_log', 'Case Log (specialty template, when required)', 13, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec15_14', 'pkt_demo_spec15', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'na', '', datetime('now', '-6 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec15_1', 'pkt_demo_spec15', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec15_2', 'pkt_demo_spec15', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec15_3', 'pkt_demo_spec15', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec15_4', 'pkt_demo_spec15', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec15_5', 'pkt_demo_spec15', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Plastic Surgery: Megan Cole, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec16',
  'Megan Cole, MD',
  'surgeon',
  'plastic',
  'new',
  '["Plastic Surgery — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-21 days'),
  datetime('now', '-1 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec16_01', 'pkt_demo_spec16', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-20 days')),
  ('item_demo_spec16_02', 'pkt_demo_spec16', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-19 days')),
  ('item_demo_spec16_03', 'pkt_demo_spec16', 'board_cert', 'Proof of Board Certification', 3, 'pending', '', datetime('now', '-18 days')),
  ('item_demo_spec16_04', 'pkt_demo_spec16', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'pending', '', datetime('now', '-17 days')),
  ('item_demo_spec16_05', 'pkt_demo_spec16', 'dea', 'DEA Certificate', 5, 'pending', '', datetime('now', '-16 days')),
  ('item_demo_spec16_06', 'pkt_demo_spec16', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-15 days')),
  ('item_demo_spec16_07', 'pkt_demo_spec16', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-14 days')),
  ('item_demo_spec16_08', 'pkt_demo_spec16', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-13 days')),
  ('item_demo_spec16_09', 'pkt_demo_spec16', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-12 days')),
  ('item_demo_spec16_10', 'pkt_demo_spec16', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-11 days')),
  ('item_demo_spec16_11', 'pkt_demo_spec16', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-10 days')),
  ('item_demo_spec16_12', 'pkt_demo_spec16', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-9 days')),
  ('item_demo_spec16_13', 'pkt_demo_spec16', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-8 days')),
  ('item_demo_spec16_14', 'pkt_demo_spec16', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-7 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec16_1', 'pkt_demo_spec16', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec16_2', 'pkt_demo_spec16', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec16_3', 'pkt_demo_spec16', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec16_4', 'pkt_demo_spec16', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec16_5', 'pkt_demo_spec16', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Podiatry: Diana Wells, DPM
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec17',
  'Diana Wells, DPM',
  'surgeon',
  'podiatry',
  'new',
  '["Podiatry — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-22 days'),
  datetime('now', '-2 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec17_01', 'pkt_demo_spec17', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-21 days')),
  ('item_demo_spec17_02', 'pkt_demo_spec17', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-20 days')),
  ('item_demo_spec17_03', 'pkt_demo_spec17', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-19 days')),
  ('item_demo_spec17_04', 'pkt_demo_spec17', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-18 days')),
  ('item_demo_spec17_05', 'pkt_demo_spec17', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-17 days')),
  ('item_demo_spec17_06', 'pkt_demo_spec17', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-16 days')),
  ('item_demo_spec17_07', 'pkt_demo_spec17', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-15 days')),
  ('item_demo_spec17_08', 'pkt_demo_spec17', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-14 days')),
  ('item_demo_spec17_09', 'pkt_demo_spec17', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-13 days')),
  ('item_demo_spec17_10', 'pkt_demo_spec17', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-12 days')),
  ('item_demo_spec17_11', 'pkt_demo_spec17', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-11 days')),
  ('item_demo_spec17_12', 'pkt_demo_spec17', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-10 days')),
  ('item_demo_spec17_13', 'pkt_demo_spec17', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-9 days')),
  ('item_demo_spec17_14', 'pkt_demo_spec17', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-8 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec17_1', 'pkt_demo_spec17', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec17_2', 'pkt_demo_spec17', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec17_3', 'pkt_demo_spec17', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec17_4', 'pkt_demo_spec17', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec17_5', 'pkt_demo_spec17', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Podiatry: Eric Hoffman, DPM
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec18',
  'Eric Hoffman, DPM',
  'surgeon',
  'podiatry',
  'recred',
  '["Podiatry — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-23 days'),
  datetime('now', '-3 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec18_01', 'pkt_demo_spec18', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-22 days')),
  ('item_demo_spec18_02', 'pkt_demo_spec18', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-21 days')),
  ('item_demo_spec18_03', 'pkt_demo_spec18', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-20 days')),
  ('item_demo_spec18_04', 'pkt_demo_spec18', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-19 days')),
  ('item_demo_spec18_05', 'pkt_demo_spec18', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-18 days')),
  ('item_demo_spec18_06', 'pkt_demo_spec18', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-17 days')),
  ('item_demo_spec18_07', 'pkt_demo_spec18', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-16 days')),
  ('item_demo_spec18_08', 'pkt_demo_spec18', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-15 days')),
  ('item_demo_spec18_09', 'pkt_demo_spec18', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-14 days')),
  ('item_demo_spec18_10', 'pkt_demo_spec18', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-13 days')),
  ('item_demo_spec18_11', 'pkt_demo_spec18', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-12 days')),
  ('item_demo_spec18_12', 'pkt_demo_spec18', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-11 days')),
  ('item_demo_spec18_13', 'pkt_demo_spec18', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-10 days')),
  ('item_demo_spec18_14', 'pkt_demo_spec18', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-9 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec18_1', 'pkt_demo_spec18', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec18_2', 'pkt_demo_spec18', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec18_3', 'pkt_demo_spec18', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec18_4', 'pkt_demo_spec18', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec18_5', 'pkt_demo_spec18', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Urology: Jonathan Lee, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec19',
  'Jonathan Lee, MD',
  'surgeon',
  'urology',
  'new',
  '["Urology — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-24 days'),
  datetime('now', '-4 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec19_01', 'pkt_demo_spec19', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-23 days')),
  ('item_demo_spec19_02', 'pkt_demo_spec19', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-22 days')),
  ('item_demo_spec19_03', 'pkt_demo_spec19', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-21 days')),
  ('item_demo_spec19_04', 'pkt_demo_spec19', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-20 days')),
  ('item_demo_spec19_05', 'pkt_demo_spec19', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-19 days')),
  ('item_demo_spec19_06', 'pkt_demo_spec19', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-18 days')),
  ('item_demo_spec19_07', 'pkt_demo_spec19', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-17 days')),
  ('item_demo_spec19_08', 'pkt_demo_spec19', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-16 days')),
  ('item_demo_spec19_09', 'pkt_demo_spec19', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-15 days')),
  ('item_demo_spec19_10', 'pkt_demo_spec19', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-14 days')),
  ('item_demo_spec19_11', 'pkt_demo_spec19', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-13 days')),
  ('item_demo_spec19_12', 'pkt_demo_spec19', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-12 days')),
  ('item_demo_spec19_13', 'pkt_demo_spec19', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-11 days')),
  ('item_demo_spec19_14', 'pkt_demo_spec19', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-10 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec19_1', 'pkt_demo_spec19', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec19_2', 'pkt_demo_spec19', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec19_3', 'pkt_demo_spec19', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec19_4', 'pkt_demo_spec19', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec19_5', 'pkt_demo_spec19', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Urology: Samantha Ortiz, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec20',
  'Samantha Ortiz, MD',
  'surgeon',
  'urology',
  'new',
  '["Urology — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-5 days'),
  datetime('now', '-1 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec20_01', 'pkt_demo_spec20', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec20_02', 'pkt_demo_spec20', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec20_03', 'pkt_demo_spec20', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-2 days')),
  ('item_demo_spec20_04', 'pkt_demo_spec20', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec20_05', 'pkt_demo_spec20', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec20_06', 'pkt_demo_spec20', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec20_07', 'pkt_demo_spec20', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec20_08', 'pkt_demo_spec20', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec20_09', 'pkt_demo_spec20', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec20_10', 'pkt_demo_spec20', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec20_11', 'pkt_demo_spec20', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec20_12', 'pkt_demo_spec20', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec20_13', 'pkt_demo_spec20', 'case_log', 'Case Log (specialty template, when required)', 13, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec20_14', 'pkt_demo_spec20', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'na', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec20_1', 'pkt_demo_spec20', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec20_2', 'pkt_demo_spec20', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec20_3', 'pkt_demo_spec20', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec20_4', 'pkt_demo_spec20', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec20_5', 'pkt_demo_spec20', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Urology: David Klein, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec21',
  'David Klein, MD',
  'surgeon',
  'urology',
  'recred',
  '["Urology — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-6 days'),
  datetime('now', '-2 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec21_01', 'pkt_demo_spec21', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec21_02', 'pkt_demo_spec21', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec21_03', 'pkt_demo_spec21', 'board_cert', 'Proof of Board Certification', 3, 'pending', '', datetime('now', '-3 days')),
  ('item_demo_spec21_04', 'pkt_demo_spec21', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'pending', '', datetime('now', '-2 days')),
  ('item_demo_spec21_05', 'pkt_demo_spec21', 'dea', 'DEA Certificate', 5, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec21_06', 'pkt_demo_spec21', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec21_07', 'pkt_demo_spec21', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec21_08', 'pkt_demo_spec21', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec21_09', 'pkt_demo_spec21', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec21_10', 'pkt_demo_spec21', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec21_11', 'pkt_demo_spec21', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec21_12', 'pkt_demo_spec21', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec21_13', 'pkt_demo_spec21', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec21_14', 'pkt_demo_spec21', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec21_1', 'pkt_demo_spec21', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec21_2', 'pkt_demo_spec21', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec21_3', 'pkt_demo_spec21', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec21_4', 'pkt_demo_spec21', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec21_5', 'pkt_demo_spec21', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Pain Medicine: Karen Blake, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec22',
  'Karen Blake, MD',
  'surgeon',
  'pain',
  'new',
  '["Pain Medicine — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-7 days'),
  datetime('now', '-3 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec22_01', 'pkt_demo_spec22', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec22_02', 'pkt_demo_spec22', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec22_03', 'pkt_demo_spec22', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec22_04', 'pkt_demo_spec22', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec22_05', 'pkt_demo_spec22', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-2 days')),
  ('item_demo_spec22_06', 'pkt_demo_spec22', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec22_07', 'pkt_demo_spec22', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec22_08', 'pkt_demo_spec22', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec22_09', 'pkt_demo_spec22', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec22_10', 'pkt_demo_spec22', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec22_11', 'pkt_demo_spec22', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec22_12', 'pkt_demo_spec22', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec22_13', 'pkt_demo_spec22', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec22_14', 'pkt_demo_spec22', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec22_1', 'pkt_demo_spec22', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec22_2', 'pkt_demo_spec22', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec22_3', 'pkt_demo_spec22', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec22_4', 'pkt_demo_spec22', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec22_5', 'pkt_demo_spec22', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Pain Medicine: Victor Nguyen, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec23',
  'Victor Nguyen, MD',
  'surgeon',
  'pain',
  'new',
  '["Pain Medicine — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-8 days'),
  datetime('now', '-4 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec23_01', 'pkt_demo_spec23', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec23_02', 'pkt_demo_spec23', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec23_03', 'pkt_demo_spec23', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec23_04', 'pkt_demo_spec23', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec23_05', 'pkt_demo_spec23', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec23_06', 'pkt_demo_spec23', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-2 days')),
  ('item_demo_spec23_07', 'pkt_demo_spec23', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec23_08', 'pkt_demo_spec23', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec23_09', 'pkt_demo_spec23', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec23_10', 'pkt_demo_spec23', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec23_11', 'pkt_demo_spec23', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec23_12', 'pkt_demo_spec23', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec23_13', 'pkt_demo_spec23', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec23_14', 'pkt_demo_spec23', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec23_1', 'pkt_demo_spec23', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec23_2', 'pkt_demo_spec23', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec23_3', 'pkt_demo_spec23', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec23_4', 'pkt_demo_spec23', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec23_5', 'pkt_demo_spec23', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Pain Medicine: Emily Hart, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec24',
  'Emily Hart, MD',
  'surgeon',
  'pain',
  'recred',
  '["Pain Medicine — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-9 days'),
  datetime('now', '-1 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec24_01', 'pkt_demo_spec24', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec24_02', 'pkt_demo_spec24', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec24_03', 'pkt_demo_spec24', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec24_04', 'pkt_demo_spec24', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec24_05', 'pkt_demo_spec24', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec24_06', 'pkt_demo_spec24', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec24_07', 'pkt_demo_spec24', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-2 days')),
  ('item_demo_spec24_08', 'pkt_demo_spec24', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec24_09', 'pkt_demo_spec24', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec24_10', 'pkt_demo_spec24', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec24_11', 'pkt_demo_spec24', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec24_12', 'pkt_demo_spec24', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec24_13', 'pkt_demo_spec24', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec24_14', 'pkt_demo_spec24', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec24_1', 'pkt_demo_spec24', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec24_2', 'pkt_demo_spec24', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec24_3', 'pkt_demo_spec24', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec24_4', 'pkt_demo_spec24', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec24_5', 'pkt_demo_spec24', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Physician Assistant: Jordan Miles, PA-C
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec25',
  'Jordan Miles, PA-C',
  'pa',
  'pa',
  'new',
  '["Physician Assistant — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-10 days'),
  datetime('now', '-2 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec25_01', 'pkt_demo_spec25', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec25_02', 'pkt_demo_spec25', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec25_03', 'pkt_demo_spec25', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec25_04', 'pkt_demo_spec25', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec25_05', 'pkt_demo_spec25', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec25_06', 'pkt_demo_spec25', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec25_07', 'pkt_demo_spec25', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec25_08', 'pkt_demo_spec25', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-2 days')),
  ('item_demo_spec25_09', 'pkt_demo_spec25', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec25_10', 'pkt_demo_spec25', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec25_11', 'pkt_demo_spec25', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec25_12', 'pkt_demo_spec25', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'complete', '', datetime('now', '-1 days')),
  ('item_demo_spec25_13', 'pkt_demo_spec25', 'case_log', 'Case Log (specialty template, when required)', 13, 'na', '', datetime('now', '-1 days')),
  ('item_demo_spec25_14', 'pkt_demo_spec25', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'na', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec25_1', 'pkt_demo_spec25', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec25_2', 'pkt_demo_spec25', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec25_3', 'pkt_demo_spec25', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec25_4', 'pkt_demo_spec25', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec25_5', 'pkt_demo_spec25', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Physician Assistant: Taylor Brooks, PA-C
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec26',
  'Taylor Brooks, PA-C',
  'pa',
  'pa',
  'new',
  '["Physician Assistant — Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-11 days'),
  datetime('now', '-3 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec26_01', 'pkt_demo_spec26', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec26_02', 'pkt_demo_spec26', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec26_03', 'pkt_demo_spec26', 'board_cert', 'Proof of Board Certification', 3, 'pending', '', datetime('now', '-8 days')),
  ('item_demo_spec26_04', 'pkt_demo_spec26', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'pending', '', datetime('now', '-7 days')),
  ('item_demo_spec26_05', 'pkt_demo_spec26', 'dea', 'DEA Certificate', 5, 'pending', '', datetime('now', '-6 days')),
  ('item_demo_spec26_06', 'pkt_demo_spec26', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-5 days')),
  ('item_demo_spec26_07', 'pkt_demo_spec26', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-4 days')),
  ('item_demo_spec26_08', 'pkt_demo_spec26', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-3 days')),
  ('item_demo_spec26_09', 'pkt_demo_spec26', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-2 days')),
  ('item_demo_spec26_10', 'pkt_demo_spec26', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec26_11', 'pkt_demo_spec26', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec26_12', 'pkt_demo_spec26', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec26_13', 'pkt_demo_spec26', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec26_14', 'pkt_demo_spec26', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec26_1', 'pkt_demo_spec26', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec26_2', 'pkt_demo_spec26', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec26_3', 'pkt_demo_spec26', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec26_4', 'pkt_demo_spec26', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec26_5', 'pkt_demo_spec26', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Anesthesiology — Physician: Hannah Price, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec27',
  'Hannah Price, MD',
  'anesthesia',
  'anesthesia_physician',
  'recred',
  '["Anesthesiology — Physician Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-12 days'),
  datetime('now', '-4 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec27_01', 'pkt_demo_spec27', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-11 days')),
  ('item_demo_spec27_02', 'pkt_demo_spec27', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec27_03', 'pkt_demo_spec27', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec27_04', 'pkt_demo_spec27', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec27_05', 'pkt_demo_spec27', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec27_06', 'pkt_demo_spec27', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'pending', '', datetime('now', '-6 days')),
  ('item_demo_spec27_07', 'pkt_demo_spec27', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'pending', '', datetime('now', '-5 days')),
  ('item_demo_spec27_08', 'pkt_demo_spec27', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'pending', '', datetime('now', '-4 days')),
  ('item_demo_spec27_09', 'pkt_demo_spec27', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-3 days')),
  ('item_demo_spec27_10', 'pkt_demo_spec27', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-2 days')),
  ('item_demo_spec27_11', 'pkt_demo_spec27', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec27_12', 'pkt_demo_spec27', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec27_13', 'pkt_demo_spec27', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec27_14', 'pkt_demo_spec27', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec27_1', 'pkt_demo_spec27', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec27_2', 'pkt_demo_spec27', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec27_3', 'pkt_demo_spec27', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec27_4', 'pkt_demo_spec27', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec27_5', 'pkt_demo_spec27', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Anesthesiology — Physician: Robert Singh, MD
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec28',
  'Robert Singh, MD',
  'anesthesia',
  'anesthesia_physician',
  'new',
  '["Anesthesiology — Physician Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-13 days'),
  datetime('now', '-1 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec28_01', 'pkt_demo_spec28', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_spec28_02', 'pkt_demo_spec28', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-11 days')),
  ('item_demo_spec28_03', 'pkt_demo_spec28', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec28_04', 'pkt_demo_spec28', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec28_05', 'pkt_demo_spec28', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec28_06', 'pkt_demo_spec28', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec28_07', 'pkt_demo_spec28', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec28_08', 'pkt_demo_spec28', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec28_09', 'pkt_demo_spec28', 'physical_exam', 'Physical Examination Form', 9, 'pending', '', datetime('now', '-4 days')),
  ('item_demo_spec28_10', 'pkt_demo_spec28', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'pending', '', datetime('now', '-3 days')),
  ('item_demo_spec28_11', 'pkt_demo_spec28', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'pending', '', datetime('now', '-2 days')),
  ('item_demo_spec28_12', 'pkt_demo_spec28', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec28_13', 'pkt_demo_spec28', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec28_14', 'pkt_demo_spec28', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec28_1', 'pkt_demo_spec28', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec28_2', 'pkt_demo_spec28', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec28_3', 'pkt_demo_spec28', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec28_4', 'pkt_demo_spec28', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec28_5', 'pkt_demo_spec28', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Anesthesiology — CRNA: Lisa Morgan, CRNA
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec29',
  'Lisa Morgan, CRNA',
  'anesthesia',
  'anesthesia_crna',
  'new',
  '["Anesthesiology — CRNA Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-14 days'),
  datetime('now', '-2 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec29_01', 'pkt_demo_spec29', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-13 days')),
  ('item_demo_spec29_02', 'pkt_demo_spec29', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_spec29_03', 'pkt_demo_spec29', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-11 days')),
  ('item_demo_spec29_04', 'pkt_demo_spec29', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec29_05', 'pkt_demo_spec29', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec29_06', 'pkt_demo_spec29', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec29_07', 'pkt_demo_spec29', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec29_08', 'pkt_demo_spec29', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec29_09', 'pkt_demo_spec29', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec29_10', 'pkt_demo_spec29', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec29_11', 'pkt_demo_spec29', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec29_12', 'pkt_demo_spec29', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'pending', '', datetime('now', '-2 days')),
  ('item_demo_spec29_13', 'pkt_demo_spec29', 'case_log', 'Case Log (specialty template, when required)', 13, 'pending', '', datetime('now', '-1 days')),
  ('item_demo_spec29_14', 'pkt_demo_spec29', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'pending', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec29_1', 'pkt_demo_spec29', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec29_2', 'pkt_demo_spec29', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec29_3', 'pkt_demo_spec29', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec29_4', 'pkt_demo_spec29', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec29_5', 'pkt_demo_spec29', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

-- Anesthesiology — CRNA: Kevin Duffy, CRNA
INSERT OR IGNORE INTO packets (
  id, provider_name, provider_type, specialty, credentialing_type,
  privilege_blocks, status, notes, created_by, created_at, updated_at
) VALUES (
  'pkt_demo_spec30',
  'Kevin Duffy, CRNA',
  'anesthesia',
  'anesthesia_crna',
  'recred',
  '["Anesthesiology — CRNA Core Privileges"]',
  'in_progress',
  '',
  'usr_admin',
  datetime('now', '-15 days'),
  datetime('now', '-3 days')
);

INSERT OR IGNORE INTO packet_items (id, packet_id, item_key, label, sort_order, status, notes, updated_at) VALUES
  ('item_demo_spec30_01', 'pkt_demo_spec30', 'references', 'Three Professional References', 1, 'complete', '', datetime('now', '-14 days')),
  ('item_demo_spec30_02', 'pkt_demo_spec30', 'photo_id', 'Government-issued Photo ID', 2, 'complete', '', datetime('now', '-13 days')),
  ('item_demo_spec30_03', 'pkt_demo_spec30', 'board_cert', 'Proof of Board Certification', 3, 'complete', '', datetime('now', '-12 days')),
  ('item_demo_spec30_04', 'pkt_demo_spec30', 'nys_license', 'New York State Medical/PA/CRNA License Certificate', 4, 'complete', '', datetime('now', '-11 days')),
  ('item_demo_spec30_05', 'pkt_demo_spec30', 'dea', 'DEA Certificate', 5, 'complete', '', datetime('now', '-10 days')),
  ('item_demo_spec30_06', 'pkt_demo_spec30', 'mandated_reporter', 'Mandated Reporter Training Certificate', 6, 'complete', '', datetime('now', '-9 days')),
  ('item_demo_spec30_07', 'pkt_demo_spec30', 'malpractice', 'Proof of Professional Liability Coverage (Mount Sinai providers: request certificate from Mount Sinai)', 7, 'complete', '', datetime('now', '-8 days')),
  ('item_demo_spec30_08', 'pkt_demo_spec30', 'health_assessment', 'Health Assessment (completed, dated, and signed by MD/DO/PA/NP)', 8, 'complete', '', datetime('now', '-7 days')),
  ('item_demo_spec30_09', 'pkt_demo_spec30', 'physical_exam', 'Physical Examination Form', 9, 'complete', '', datetime('now', '-6 days')),
  ('item_demo_spec30_10', 'pkt_demo_spec30', 'quantiferon', 'Quantiferon TB Test dated within 3 months', 10, 'complete', '', datetime('now', '-5 days')),
  ('item_demo_spec30_11', 'pkt_demo_spec30', 'immunizations', 'Immunization Records — MMR, Hep B, and Influenza', 11, 'complete', '', datetime('now', '-4 days')),
  ('item_demo_spec30_12', 'pkt_demo_spec30', 'dop_form', 'Delineation of Privileges (DOP) Form — signed and completed', 12, 'complete', '', datetime('now', '-3 days')),
  ('item_demo_spec30_13', 'pkt_demo_spec30', 'case_log', 'Case Log (specialty template, when required)', 13, 'na', '', datetime('now', '-2 days')),
  ('item_demo_spec30_14', 'pkt_demo_spec30', 'training_certs', 'Training Certificates if applicable (BLS, ACLS, Laser/OR Fire Safety, Fluoroscopy, Chemo Admin)', 14, 'na', '', datetime('now', '-1 days'));

INSERT OR IGNORE INTO votes (id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution) VALUES
  ('vote_demo_spec30_1', 'pkt_demo_spec30', 'usr_ken_long', 'Ken Long', NULL, '', ''),
  ('vote_demo_spec30_2', 'pkt_demo_spec30', 'usr_michael_gorin', 'Michael Gorin', NULL, '', ''),
  ('vote_demo_spec30_3', 'pkt_demo_spec30', 'usr_michael_herman', 'Michael Herman', NULL, '', ''),
  ('vote_demo_spec30_4', 'pkt_demo_spec30', 'usr_vijay_mukhija', 'Vijay Mukhija', NULL, '', ''),
  ('vote_demo_spec30_5', 'pkt_demo_spec30', 'usr_stelios', 'Stelios Koutsoumbelis', NULL, '', '');

