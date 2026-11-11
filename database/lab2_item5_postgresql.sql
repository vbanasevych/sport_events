DO $$
DECLARE
i INT;
    v_match_id INT;
BEGIN
    -- Створюємо матч
INSERT INTO live_matches (match_id, sport) VALUES (999, 'Football') RETURNING id INTO v_match_id;

-- Генеруємо 50,000 подій для цього матчу
FOR i IN 1..50000 LOOP
        INSERT INTO live_events (live_match_id, event_minute, event_type, description)
        VALUES (v_match_id, i % 90, 'TEST_EVENT', 'Test description ' || i);
END LOOP;
END $$;

-- ТЕСТ ЧИТАННЯ SQL
EXPLAIN ANALYZE
SELECT * FROM live_events WHERE live_match_id = (SELECT id FROM live_matches WHERE match_id = 999);