-- Ensure Rich Searles is an active board member and has a vote slot on every packet.
-- Closed packets get a Yes so approved/denied outcomes stay intact; open packets get an empty slot.

INSERT OR IGNORE INTO users (
  id, username, display_name, email, role, password_hash, password_salt,
  must_change_password, active
)
VALUES (
  'usr_rich_searles',
  'rich.searles',
  'Rich Searles',
  '',
  'board',
  'xByJbYMl7L6FW0S5CzcYCkdLB4g646CujPEiZkubqTw=',
  'Ip5wnjb9lEG+qHjKOtsOhg==',
  1,
  1
);

UPDATE users
SET
  display_name = 'Rich Searles',
  role = 'board',
  active = 1
WHERE id = 'usr_rich_searles';

-- Open / in-flight packets: empty vote slot for Rich
INSERT OR IGNORE INTO votes (
  id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution
)
SELECT
  'vote_' || p.id || '_rich_searles',
  p.id,
  'usr_rich_searles',
  'Rich Searles',
  NULL,
  '',
  ''
FROM packets p
WHERE p.status IN ('in_progress', 'query_pending', 'ready_for_review');

-- Approved packets: Yes so the closed outcome remains unanimous Yes
INSERT OR IGNORE INTO votes (
  id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution, voted_at
)
SELECT
  'vote_' || p.id || '_rich_searles',
  p.id,
  'usr_rich_searles',
  'Rich Searles',
  'yes',
  '',
  '',
  coalesce(p.closed_at, datetime('now'))
FROM packets p
WHERE p.status = 'approved';

-- Denied packets: Yes (existing No votes still keep the packet denied)
INSERT OR IGNORE INTO votes (
  id, packet_id, voter_user_id, voter_name, vote, concern, query_resolution, voted_at
)
SELECT
  'vote_' || p.id || '_rich_searles',
  p.id,
  'usr_rich_searles',
  'Rich Searles',
  'yes',
  '',
  '',
  coalesce(p.closed_at, datetime('now'))
FROM packets p
WHERE p.status = 'denied';
