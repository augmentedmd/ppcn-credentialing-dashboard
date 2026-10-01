-- Ensure users.role CHECK allows 'watcher', then mark the demo watcher correctly.
-- Older installs may still only allow admin/board, which forces usr_watcher to role=board.

PRAGMA foreign_keys = OFF;

CREATE TABLE users_new (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL UNIQUE COLLATE NOCASE,
  display_name TEXT NOT NULL,
  email TEXT DEFAULT '',
  role TEXT NOT NULL CHECK (role IN ('admin', 'board', 'watcher')),
  password_hash TEXT NOT NULL,
  password_salt TEXT NOT NULL,
  must_change_password INTEGER NOT NULL DEFAULT 1,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

INSERT INTO users_new (
  id, username, display_name, email, role, password_hash, password_salt,
  must_change_password, active, created_at
)
SELECT
  id,
  username,
  display_name,
  COALESCE(email, ''),
  CASE
    WHEN id = 'usr_watcher' OR lower(username) = 'watcher' THEN 'watcher'
    ELSE role
  END,
  password_hash,
  password_salt,
  must_change_password,
  active,
  created_at
FROM users;

DROP TABLE users;
ALTER TABLE users_new RENAME TO users;

PRAGMA foreign_keys = ON;

UPDATE users
SET
  username = 'watcher',
  display_name = 'Watcher',
  role = 'watcher',
  active = 1
WHERE id = 'usr_watcher' OR lower(username) = 'watcher';

-- Watchers must never appear in governing board vote slots.
DELETE FROM votes
WHERE voter_user_id = 'usr_watcher'
   OR lower(voter_name) = 'watcher'
   OR voter_user_id IN (
     SELECT id FROM users WHERE role = 'watcher' OR lower(username) = 'watcher'
   );
