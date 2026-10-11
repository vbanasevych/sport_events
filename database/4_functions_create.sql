-- 8. Функція для розрахунку загального доходу з квитків для конкретної події
CREATE OR REPLACE FUNCTION fn_event_revenue(p_event_id INT)
RETURNS DECIMAL(12,2) AS $$
DECLARE
    total_rev DECIMAL(12,2);
BEGIN
    SELECT COALESCE(SUM(price), 0) INTO total_rev 
    FROM tickets WHERE event_id = p_event_id AND is_sold = TRUE;
    RETURN total_rev;
END;
$$ LANGUAGE plpgsql;

-- 9. Функція розрахунку "Вінрейту" (відсотка перемог) команди
CREATE OR REPLACE FUNCTION fn_team_win_rate(p_team_id INT)
RETURNS NUMERIC AS $$
DECLARE
    total_matches INT;
    won_matches INT;
BEGIN
    SELECT COUNT(*) INTO total_matches FROM match_participants WHERE team_id = p_team_id;
    IF total_matches = 0 THEN RETURN 0; END IF;
    
    SELECT COUNT(*) INTO won_matches FROM match_participants WHERE team_id = p_team_id AND is_winner = TRUE;
    
    RETURN ROUND((won_matches::NUMERIC / total_matches::NUMERIC) * 100, 2);
END;
$$ LANGUAGE plpgsql;

-- 10. Функція для підрахунку кількості вільних місць на локації для події
CREATE OR REPLACE FUNCTION fn_get_available_seats(p_event_id INT)
RETURNS INT AS $$
DECLARE
    v_capacity INT;
    v_sold_tickets INT;
BEGIN
    SELECT l.capacity INTO v_capacity 
    FROM events e JOIN locations l ON e.location_id = l.id WHERE e.id = p_event_id;
    
    SELECT COUNT(*) INTO v_sold_tickets 
    FROM tickets WHERE event_id = p_event_id AND is_sold = TRUE;
    
    RETURN COALESCE(v_capacity - v_sold_tickets, 0);
END;
$$ LANGUAGE plpgsql;

-- 11. Функція, що повертає таблицю (список учасників турніру)
CREATE OR REPLACE FUNCTION fn_get_event_participants(p_event_id INT)
RETURNS TABLE (team_name VARCHAR, first_name VARCHAR, last_name VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT t.name, a.first_name, a.last_name
    FROM event_participants ep
    LEFT JOIN teams t ON ep.team_id = t.id
    LEFT JOIN athletes a ON ep.athlete_id = a.id
    WHERE ep.event_id = p_event_id;
END;
$$ LANGUAGE plpgsql;