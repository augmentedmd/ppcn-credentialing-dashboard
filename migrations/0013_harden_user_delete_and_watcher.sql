-- Documented production repair: users.role CHECK must allow 'watcher'.
-- Safe to re-run on databases that already allow watcher (no-op path via IGNORE).
-- Full rebuild is only needed when CHECK is still admin/board-only; apply via
-- migrations/0011_watcher_role_constraint.sql (or the equivalent D1 rebuild).

-- Ensure demo watcher is role=watcher when the schema allows it.
UPDATE users
SET role = 'watcher', active = 1, display_name = 'Watcher', username = 'watcher'
WHERE id = 'usr_watcher' OR lower(username) = 'watcher';

-- Remove vote slots for inactive or non-board users (deleted board members, watchers).
DELETE FROM votes
WHERE voter_user_id NOT IN (
  SELECT id FROM users
  WHERE role = 'board' AND active = 1
    AND id != 'usr_watcher' AND lower(username) != 'watcher'
);
