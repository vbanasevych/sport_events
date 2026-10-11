-- 12. Каскадний Soft Delete локації (видаляємо локацію та скасовуємо всі події на ній)
CREATE OR REPLACE PROCEDURE sp_soft_delete_location(p_location_id INT, p_user_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    -- Позначаємо локацію як видалену і записуємо аудитора
    UPDATE locations
    SET is_deleted = TRUE, updated_by = p_user_id
    WHERE id = p_location_id;

    -- Скасовуємо і "видаляємо" всі події на цій локації
    UPDATE events
    SET is_deleted = TRUE, status = 'CANCELLED', updated_by = p_user_id
    WHERE location_id = p_location_id AND is_deleted = FALSE;
END;
$$;

-- 13. Процедура купівлі квитка (з перевіркою чи він ще не проданий)
CREATE OR REPLACE PROCEDURE sp_buy_ticket(p_ticket_id INT, p_user_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    -- Блокування рядка для запобігання гонці (Race condition)
    PERFORM 1 FROM tickets WHERE id = p_ticket_id FOR UPDATE;

    IF EXISTS (SELECT 1 FROM tickets WHERE id = p_ticket_id AND is_sold = TRUE) THEN
        RAISE EXCEPTION 'Квиток вже продано!';
    END IF;

    UPDATE tickets
    SET is_sold = TRUE, purchased_by = p_user_id
    WHERE id = p_ticket_id;
END;
$$;

-- 14. Soft Delete події (і її матчів)
CREATE OR REPLACE PROCEDURE sp_soft_delete_event(p_event_id INT, p_user_id INT)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE events SET is_deleted = TRUE, updated_by = p_user_id WHERE id = p_event_id;
    UPDATE matches SET is_deleted = TRUE, updated_by = p_user_id WHERE event_id = p_event_id AND is_deleted = FALSE;
END;
$$;

-- 15. Реєстрація результату матчу
CREATE OR REPLACE PROCEDURE sp_update_match_score(
    p_match_id INT, p_team_id INT, p_score INT, p_is_winner BOOLEAN
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE match_participants
    SET score = p_score, is_winner = p_is_winner
    WHERE match_id = p_match_id AND team_id = p_team_id;
END;
$$;