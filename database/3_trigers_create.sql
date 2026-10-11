-- 5. Тригерна функція для автоматичного оновлення поля updated_at
CREATE OR REPLACE FUNCTION trg_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Прив'язуємо тригер до таблиць з аудитом
CREATE TRIGGER trg_events_updated_at BEFORE UPDATE ON events FOR EACH ROW EXECUTE FUNCTION trg_set_updated_at();
CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION trg_set_updated_at();
CREATE TRIGGER trg_locations_updated_at BEFORE UPDATE ON locations FOR EACH ROW EXECUTE FUNCTION trg_set_updated_at();
CREATE TRIGGER trg_matches_updated_at BEFORE UPDATE ON matches FOR EACH ROW EXECUTE FUNCTION trg_set_updated_at();

-- 6. Тригер для заборони Hard Delete (фізичного видалення) подій
CREATE OR REPLACE FUNCTION trg_prevent_hard_delete()
RETURNS TRIGGER AS $$
BEGIN
    RAISE EXCEPTION 'Фізичне видалення заборонено. Використовуйте Soft Delete (is_deleted = TRUE).';
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_event_hard_delete BEFORE DELETE ON events FOR EACH ROW EXECUTE FUNCTION trg_prevent_hard_delete();

-- 7. Тригер-валідатор: перевірка, чи матч призначено в межах дат самої події
CREATE OR REPLACE FUNCTION trg_check_match_date()
RETURNS TRIGGER AS $$
DECLARE
    v_start_date TIMESTAMP;
    v_end_date TIMESTAMP;
BEGIN
    SELECT start_date, end_date INTO v_start_date, v_end_date FROM events WHERE id = NEW.event_id;
    IF NEW.match_time < v_start_date OR NEW.match_time > v_end_date THEN
        RAISE EXCEPTION 'Час матчу (%) виходить за межі дат турніру (% - %)', NEW.match_time, v_start_date, v_end_date;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_matches_date_check BEFORE INSERT OR UPDATE ON matches FOR EACH ROW EXECUTE FUNCTION trg_check_match_date();