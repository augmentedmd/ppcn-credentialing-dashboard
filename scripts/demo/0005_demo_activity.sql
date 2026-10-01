-- Sample activity events for demo packets (requires 0003_demo_packets.sql).
-- Safe to re-run (INSERT OR IGNORE).

INSERT OR IGNORE INTO packet_events (id, packet_id, actor_user_id, actor_name, event_type, summary, detail, created_at) VALUES
  -- Blank packet
  ('evt_demo_blank_01', 'pkt_demo_blank', 'usr_admin', 'Credentialing Admin', 'packet_created',
   'Opened credentialing packet for Kevin Morales, DPM', 'New credentialing · Podiatry', datetime('now', '-1 days')),

  -- Early packet
  ('evt_demo_early_01', 'pkt_demo_early', 'usr_admin', 'Credentialing Admin', 'packet_created',
   'Opened credentialing packet for Sarah Chen, MD', 'New credentialing · Orthopedic Surgery', datetime('now', '-18 days')),
  ('evt_demo_early_02', 'pkt_demo_early', 'usr_admin', 'Credentialing Admin', 'item_status_changed',
   'Marked “Government-issued Photo ID” Done', '', datetime('now', '-16 days')),
  ('evt_demo_early_03', 'pkt_demo_early', 'usr_admin', 'Credentialing Admin', 'item_status_changed',
   'Marked “New York State Medical/PA/CRNA License Certificate” Done', '', datetime('now', '-15 days')),

  -- Mid packet
  ('evt_demo_mid_01', 'pkt_demo_mid', 'usr_admin', 'Credentialing Admin', 'packet_created',
   'Opened credentialing packet for James Okonkwo, MD', 'New credentialing · Gastroenterology', datetime('now', '-25 days')),
  ('evt_demo_mid_02', 'pkt_demo_mid', 'usr_admin', 'Credentialing Admin', 'item_status_changed',
   'Marked “Three Professional References” Done', '', datetime('now', '-20 days')),
  ('evt_demo_mid_03', 'pkt_demo_mid', 'usr_admin', 'Credentialing Admin', 'item_status_changed',
   'Marked “Training Certificates if applicable…” N/A', '', datetime('now', '-10 days')),
  ('evt_demo_mid_04', 'pkt_demo_mid', 'usr_admin', 'Credentialing Admin', 'item_status_changed',
   'Marked “Case Log (specialty template, when required)” Pending', '', datetime('now', '-3 days')),

  -- Nearly complete
  ('evt_demo_nearly_01', 'pkt_demo_nearly', 'usr_admin', 'Credentialing Admin', 'packet_created',
   'Opened credentialing packet for Priya Patel, PA-C', 'New credentialing · Physician Assistant', datetime('now', '-30 days')),
  ('evt_demo_nearly_02', 'pkt_demo_nearly', 'usr_admin', 'Credentialing Admin', 'item_status_changed',
   'Marked “Quantiferon TB Test dated within 3 months” Pending', '', datetime('now', '-1 days')),

  -- Checklist complete
  ('evt_demo_complete_01', 'pkt_demo_complete', 'usr_admin', 'Credentialing Admin', 'packet_created',
   'Opened credentialing packet for Amanda Brooks, MD', 'New credentialing · Anesthesiology — Physician', datetime('now', '-21 days')),
  ('evt_demo_complete_02', 'pkt_demo_complete', 'usr_admin', 'Credentialing Admin', 'item_status_changed',
   'Marked “Delineation of Privileges (DOP) Form — signed and completed” Done', '', datetime('now', '-2 days')),

  -- Ready for review
  ('evt_demo_ready_01', 'pkt_demo_ready', 'usr_admin', 'Credentialing Admin', 'packet_created',
   'Opened credentialing packet for Maria Santos, MD', 'New credentialing · Gynecology', datetime('now', '-40 days')),
  ('evt_demo_ready_02', 'pkt_demo_ready', 'usr_admin', 'Credentialing Admin', 'marked_ready',
   'Marked packet Ready for Review', 'All checklist components Complete or N/A', datetime('now', '-3 days')),
  ('evt_demo_ready_03', 'pkt_demo_ready', 'usr_ken_long', 'Ken Long', 'vote_cast',
   'Voted Yes', '', datetime('now', '-2 days')),
  ('evt_demo_ready_04', 'pkt_demo_ready', 'usr_michael_gorin', 'Michael Gorin', 'vote_cast',
   'Voted Yes', '', datetime('now', '-1 days')),

  -- Query pending
  ('evt_demo_query_01', 'pkt_demo_query', 'usr_admin', 'Credentialing Admin', 'packet_created',
   'Opened credentialing packet for Robert Walsh, MD', 'Recredentialing · Otolaryngology', datetime('now', '-55 days')),
  ('evt_demo_query_02', 'pkt_demo_query', 'usr_admin', 'Credentialing Admin', 'marked_ready',
   'Marked packet Ready for Review', '', datetime('now', '-5 days')),
  ('evt_demo_query_03', 'pkt_demo_query', 'usr_ken_long', 'Ken Long', 'vote_cast',
   'Voted Yes', '', datetime('now', '-4 days')),
  ('evt_demo_query_04', 'pkt_demo_query', 'usr_michael_herman', 'Michael Herman', 'vote_cast',
   'Voted Yes', '', datetime('now', '-3 days')),
  ('evt_demo_query_05', 'pkt_demo_query', 'usr_michael_gorin', 'Michael Gorin', 'query_opened',
   'Paused for query', 'Please clarify whether sinus case volume meets renewal thresholds for the requested privilege block.', datetime('now', '-8 hours')),

  -- Approved
  ('evt_demo_approved_01', 'pkt_demo_approved', 'usr_admin', 'Credentialing Admin', 'packet_created',
   'Opened credentialing packet for Elena Vasquez, MD', 'Recredentialing · Ophthalmology', datetime('now', '-90 days')),
  ('evt_demo_approved_02', 'pkt_demo_approved', 'usr_admin', 'Credentialing Admin', 'marked_ready',
   'Marked packet Ready for Review', '', datetime('now', '-21 days')),
  ('evt_demo_approved_03', 'pkt_demo_approved', 'usr_ken_long', 'Ken Long', 'vote_cast',
   'Voted Yes', '', datetime('now', '-18 days')),
  ('evt_demo_approved_04', 'pkt_demo_approved', 'usr_michael_gorin', 'Michael Gorin', 'vote_cast',
   'Voted Yes', '', datetime('now', '-17 days')),
  ('evt_demo_approved_05', 'pkt_demo_approved', 'usr_michael_herman', 'Michael Herman', 'vote_cast',
   'Voted Yes', '', datetime('now', '-16 days')),
  ('evt_demo_approved_06', 'pkt_demo_approved', 'usr_vijay_mukhija', 'Vijay Mukhija', 'vote_cast',
   'Voted Yes', '', datetime('now', '-15 days')),
  ('evt_demo_approved_07', 'pkt_demo_approved', 'usr_stelios', 'Stelios Koutsoumbelis', 'vote_cast',
   'Voted Yes', '', datetime('now', '-14 days')),
  ('evt_demo_approved_08', 'pkt_demo_approved', NULL, 'System', 'status_changed',
   'Packet approved', 'All governing board votes were Yes', datetime('now', '-14 days')),

  -- Denied
  ('evt_demo_denied_01', 'pkt_demo_denied', 'usr_admin', 'Credentialing Admin', 'packet_created',
   'Opened credentialing packet for Thomas Nguyen, CRNA', 'New credentialing · Anesthesiology — CRNA', datetime('now', '-70 days')),
  ('evt_demo_denied_02', 'pkt_demo_denied', 'usr_admin', 'Credentialing Admin', 'marked_ready',
   'Marked packet Ready for Review', '', datetime('now', '-28 days')),
  ('evt_demo_denied_03', 'pkt_demo_denied', 'usr_michael_gorin', 'Michael Gorin', 'vote_cast',
   'Voted No', 'One reference returned incomplete details', datetime('now', '-22 days')),
  ('evt_demo_denied_04', 'pkt_demo_denied', NULL, 'System', 'status_changed',
   'Packet denied', 'At least one governing board vote was No', datetime('now', '-20 days'));
