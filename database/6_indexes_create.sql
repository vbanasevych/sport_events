-- B-Tree індекс
CREATE INDEX idx_events_date_range 
ON events USING btree (start_date, end_date);

-- Hash індекс
CREATE INDEX idx_organizers_email_hash 
ON organizers USING hash (contact_email);

-- Partial Index
CREATE INDEX idx_available_tickets 
ON tickets (event_id) 
WHERE is_sold = FALSE;

CREATE INDEX idx_active_users 
ON users (username) 
WHERE is_deleted = FALSE;

-- BRIN (Block Range Index)
CREATE INDEX idx_participants_registered_at 
ON event_participants USING brin (registered_at);