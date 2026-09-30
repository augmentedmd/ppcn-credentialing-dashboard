-- Seed users (temporary passwords — change on first login)
-- admin / ChangeMeAdmin1!
-- board members / ChangeMeBoard1!

INSERT OR IGNORE INTO users (id, username, display_name, role, password_hash, password_salt, must_change_password, active)
VALUES
  ('usr_admin', 'admin', 'Credentialing Admin', 'admin', 'XgXaK5W6XaoEToGCkt3gXRBYYhilMNo2XX0GQRvOKXc=', 'u3m5ktMgJOKJk3rpwiGPww==', 1, 1),
  ('usr_ken_long', 'ken.long', 'Ken Long', 'board', 'xByJbYMl7L6FW0S5CzcYCkdLB4g646CujPEiZkubqTw=', 'Ip5wnjb9lEG+qHjKOtsOhg==', 1, 1),
  ('usr_michael_gorin', 'michael.gorin', 'Michael Gorin', 'board', 'NREOmhZh9cAGbbaQF9aCtZTZ8xZxAXc5oqdG/ahdvus=', '1aL0M4tg24Ey/iNNXstXjg==', 1, 1),
  ('usr_michael_herman', 'michael.herman', 'Michael Herman', 'board', 'K4qOsVAbpU/be5oqBTQ6Thde/o9Zs2YuFxJU4//n1H0=', 'bz30XqIThhTjyq1pJJ5aEg==', 1, 1),
  ('usr_vijay_mukhija', 'vijay.mukhija', 'Vijay Mukhija', 'board', 'E5k3gjtP025UxL7Hs+rBz2/X+h7VqnwHYyETnImlENA=', 'uqKN8wIEGkV4kaHXmpj0RA==', 1, 1),
  ('usr_stelios', 'stelios.koutsoumbelis', 'Stelios Koutsoumbelis', 'board', 'G2sLIWMX35zZh6fpR5ZX+aermGkEGgVVw0S2FR+qGJs=', 'W7SSN5wwaeWxtVxwnDUFRA==', 1, 1);
