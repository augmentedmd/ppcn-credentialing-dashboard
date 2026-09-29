-- PeakPoint Central Nassau Credentialing Dashboard schema

CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL UNIQUE COLLATE NOCASE,
  display_name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'board')),
  password_hash TEXT NOT NULL,
  password_salt TEXT NOT NULL,
  must_change_password INTEGER NOT NULL DEFAULT 1,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS sessions (
  token TEXT PRIMARY KEY,
  user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  expires_at TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_sessions_user ON sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_expires ON sessions(expires_at);

CREATE TABLE IF NOT EXISTS packets (
  id TEXT PRIMARY KEY,
  provider_name TEXT NOT NULL,
  provider_type TEXT NOT NULL CHECK (provider_type IN ('surgeon', 'pa', 'anesthesia')),
  specialty TEXT NOT NULL,
  credentialing_type TEXT NOT NULL CHECK (credentialing_type IN ('new', 'recred')),
  privilege_blocks TEXT NOT NULL DEFAULT '[]',
  status TEXT NOT NULL DEFAULT 'in_progress'
    CHECK (status IN ('in_progress', 'ready_for_review', 'query_pending', 'approved', 'denied')),
  notes TEXT NOT NULL DEFAULT '',
  created_by TEXT REFERENCES users(id),
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  ready_at TEXT,
  closed_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_packets_status ON packets(status);
CREATE INDEX IF NOT EXISTS idx_packets_updated ON packets(updated_at);

CREATE TABLE IF NOT EXISTS packet_items (
  id TEXT PRIMARY KEY,
  packet_id TEXT NOT NULL REFERENCES packets(id) ON DELETE CASCADE,
  item_key TEXT NOT NULL,
  label TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'complete', 'na')),
  notes TEXT NOT NULL DEFAULT '',
  updated_at TEXT NOT NULL DEFAULT (datetime('now')),
  UNIQUE(packet_id, item_key)
);

CREATE INDEX IF NOT EXISTS idx_packet_items_packet ON packet_items(packet_id);

CREATE TABLE IF NOT EXISTS votes (
  id TEXT PRIMARY KEY,
  packet_id TEXT NOT NULL REFERENCES packets(id) ON DELETE CASCADE,
  voter_user_id TEXT NOT NULL REFERENCES users(id),
  voter_name TEXT NOT NULL,
  vote TEXT CHECK (vote IN ('yes', 'no', 'pause_for_query') OR vote IS NULL),
  concern TEXT NOT NULL DEFAULT '',
  query_resolution TEXT NOT NULL DEFAULT '',
  voted_at TEXT,
  resolution_at TEXT,
  UNIQUE(packet_id, voter_user_id)
);

CREATE INDEX IF NOT EXISTS idx_votes_packet ON votes(packet_id);