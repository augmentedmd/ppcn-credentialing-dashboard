-- Force-reset demo logins on existing databases.
-- Seed uses INSERT OR IGNORE, so older installs keep ChangeMe* passwords unless updated.

-- admin / admin
UPDATE users
SET
  username = 'admin',
  display_name = 'Credentialing Admin',
  role = 'admin',
  password_hash = 'EgIGFx5S1rte3mZsoy/E7AaQMSYhm+kY+OjSVFG0YHU=',
  password_salt = 'ojJknmDEvuYdayifs4rg7A==',
  must_change_password = 0,
  active = 1
WHERE id = 'usr_admin';

-- board / board  (Michael Gorin vote slot)
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

-- watcher / watcher
-- Prefer role=watcher when the CHECK constraint allows it. On older DBs that
-- only allow admin/board, insert as board; the app maps usr_watcher -> watcher.
INSERT OR IGNORE INTO users (
  id, username, display_name, role, password_hash, password_salt,
  must_change_password, active
)
VALUES (
  'usr_watcher',
  'watcher',
  'Watcher',
  'board',
  'a6eO+N+VDlG4+3YtNhNPnpEWMc6RFqMUsOLNok3aF5E=',
  '2cE6CD3u34nQMEmN10xeoQ==',
  0,
  1
);

UPDATE users
SET
  username = 'watcher',
  display_name = 'Watcher',
  password_hash = 'a6eO+N+VDlG4+3YtNhNPnpEWMc6RFqMUsOLNok3aF5E=',
  password_salt = '2cE6CD3u34nQMEmN10xeoQ==',
  must_change_password = 0,
  active = 1
WHERE id = 'usr_watcher';

-- Best-effort upgrade to role=watcher when the schema allows it.
UPDATE users SET role = 'watcher' WHERE id = 'usr_watcher';
