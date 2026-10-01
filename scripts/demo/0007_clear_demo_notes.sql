-- Clear packet and checklist notes on demo (and all) packets for a clean demo.
-- Safe to re-run.

UPDATE packets SET notes = '';
UPDATE packet_items SET notes = '';
