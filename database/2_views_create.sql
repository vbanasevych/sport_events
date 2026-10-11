-- 1. Розріз усіх АКТИВНИХ подій з деталями про локацію та вид спорту
CREATE OR REPLACE VIEW vw_active_events AS
SELECT e.id AS event_id, e.title, s.name AS sport_name, l.name AS location_name, e.start_date, e.end_date, e.status
FROM events e
JOIN sports s ON e.sport_id = s.id
JOIN locations l ON e.location_id = l.id
WHERE e.is_deleted = FALSE AND l.is_deleted = FALSE;

-- 2. Розріз аудиту подій (хто і коли їх змінював)
CREATE OR REPLACE VIEW vw_event_audit_info AS
SELECT e.id AS event_id, e.title, e.updated_at, u.username AS updated_by_user
FROM events e
JOIN users u ON e.updated_by = u.id
WHERE e.updated_at IS NOT NULL;

-- 3. Розріз доступних (непроданих) квитків на майбутні активні події
CREATE OR REPLACE VIEW vw_available_tickets AS
SELECT t.id AS ticket_id, t.price, t.seat_number, e.title AS event_title, e.start_date
FROM tickets t
JOIN events e ON t.event_id = e.id
WHERE t.is_sold = FALSE 
  AND e.is_deleted = FALSE 
  AND e.start_date > CURRENT_TIMESTAMP;

-- 4. Розріз результатів матчів
CREATE OR REPLACE VIEW vw_match_results AS
SELECT m.id AS match_id, e.title AS event_title, m.round, t.name AS team_name, mp.score, mp.is_winner
FROM match_participants mp
JOIN matches m ON mp.match_id = m.id
JOIN teams t ON mp.team_id = t.id
JOIN events e ON m.event_id = e.id
WHERE m.is_deleted = FALSE AND t.is_deleted = FALSE;