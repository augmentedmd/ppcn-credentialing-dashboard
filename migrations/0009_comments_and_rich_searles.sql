-- Add comments table and Rich Searles board member

-- Create comments table
CREATE TABLE IF NOT EXISTS packet_comments (
  id TEXT PRIMARY KEY,
  packet_id TEXT NOT NULL REFERENCES packets(id) ON DELETE CASCADE,
  user_id TEXT NOT NULL REFERENCES users(id),
  user_name TEXT NOT NULL,
  comment TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_packet_comments_packet ON packet_comments(packet_id);
CREATE INDEX IF NOT EXISTS idx_packet_comments_created ON packet_comments(created_at);

-- Add Rich Searles as a board member
-- Password: ChangeMeBoard1!
INSERT OR IGNORE INTO users (id, username, display_name, email, role, password_hash, password_salt, must_change_password, active)
VALUES ('usr_rich_searles', 'rich.searles', 'Rich Searles', '', 'board', 'xByJbYMl7L6FW0S5CzcYCkdLB4g646CujPEiZkubqTw=', 'Ip5wnjb9lEG+qHjKOtsOhg==', 1, 1);
