-- Seed users
-- Demo-friendly logins (must_change_password = 0):
--   admin / admin      → credentialing staff
--   board / board      → Michael Gorin (governing board vote)
--   watcher / watcher  → read-only observer
-- Other board members still use ChangeMeBoard1! and must change on first login.

INSERT OR IGNORE INTO users (id, username, display_name, role, password_hash, password_salt, must_change_password, active)
VALUES
  ('usr_admin', 'admin', 'Credentialing Admin', 'admin', 'EgIGFx5S1rte3mZsoy/E7AaQMSYhm+kY+OjSVFG0YHU=', 'ojJknmDEvuYdayifs4rg7A==', 0, 1),
  ('usr_ken_long', 'ken.long', 'Ken Long', 'board', 'xByJbYMl7L6FW0S5CzcYCkdLB4g646CujPEiZkubqTw=', 'Ip5wnjb9lEG+qHjKOtsOhg==', 1, 1),
  ('usr_michael_gorin', 'board', 'Michael Gorin', 'board', 'bafFcxQEuMA8UnGj5rrKLGisCNkhOiKr0zK988PseXQ=', 'Dms04v5OkphQUg2X0sSEpQ==', 0, 1),
  ('usr_michael_herman', 'michael.herman', 'Michael Herman', 'board', 'K4qOsVAbpU/be5oqBTQ6Thde/o9Zs2YuFxJU4//n1H0=', 'bz30XqIThhTjyq1pJJ5aEg==', 1, 1),
  ('usr_vijay_mukhija', 'vijay.mukhija', 'Vijay Mukhija', 'board', 'E5k3gjtP025UxL7Hs+rBz2/X+h7VqnwHYyETnImlENA=', 'uqKN8wIEGkV4kaHXmpj0RA==', 1, 1),
  ('usr_stelios', 'stelios.koutsoumbelis', 'Stelios Koutsoumbelis', 'board', 'G2sLIWMX35zZh6fpR5ZX+aermGkEGgVVw0S2FR+qGJs=', 'W7SSN5wwaeWxtVxwnDUFRA==', 1, 1),
  ('usr_watcher', 'watcher', 'Watcher', 'watcher', 'a6eO+N+VDlG4+3YtNhNPnpEWMc6RFqMUsOLNok3aF5E=', '2cE6CD3u34nQMEmN10xeoQ==', 0, 1);
