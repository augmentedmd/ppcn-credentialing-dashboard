-- Per-packet activity / audit trail

CREATE TABLE IF NOT EXISTS packet_events (
  id TEXT PRIMARY KEY,
  packet_id TEXT NOT NULL REFERENCES packets(id) ON DELETE CASCADE,
  actor_user_id TEXT REFERENCES users(id),
  actor_name TEXT NOT NULL,
  event_type TEXT NOT NULL,
  summary TEXT NOT NULL,
  detail TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_packet_events_packet ON packet_events(packet_id, created_at DESC);
