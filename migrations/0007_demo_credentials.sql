-- Demo credentials + watcher role support for existing databases.
-- Allows role = 'watcher' by rebuilding the users table CHECK constraint,
-- remaps Michael Gorin's login to board / board, and adds watcher / watcher.

PRAGMA foreign_keys = OFF;

CREATE TABLE users_new (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL UNIQUE COLLATE NOCASE,
  display_name TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'board', 'watcher')),
  password_hash TEXT NOT NULL,
  password_salt TEXT NOT NULL,
  must_change_password INTEGER NOT NULL DEFAULT 1,
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

INSERT INTO users_new (
  id, username, display_name, role, password_hash, password_salt,
  must_change_password, active, created_at
)
SELECT
  id, username, display_name, role, password_hash, password_salt,
  must_change_password, active, created_at
FROM users;

DROP TABLE users;
ALTER TABLE users_new RENAME TO users;

PRAGMA foreign_keys = ON;

-- Michael Gorin votes as board / board (no forced password change)
UPDATE users
SET
  username = 'board',
  display_name = 'Michael Gorin',
  role = 'board',
  password_hash = 'bafFcxQEuMA8UnGj5rrKLGisCNkhOiKr0zK988PseXQ=',
  password_salt = 'Dms04v5OkphQUg2X0sSEpQ==',
  must_change_password = 0,
  active = 1
WHERE id = 'usr_michael_gorin';

-- Read-only demo observer
INSERT OR IGNORE INTO users (
  id, username, display_name, role, password_hash, password_salt,
  must_change_password, active
)
VALUES (
  'usr_watcher',
  'watcher',
  'Watcher',
  'watcher',
  'a6eO+N+VDlG4+3YtNhNPnpEWMc6RFqMUsOLNok3aF5E=',
  '2cE6CD3u34nQMEmN10xeoQ==',
  0,
  1
);
