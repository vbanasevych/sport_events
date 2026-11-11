-- Загальна інформація про трансляцію матчу
CREATE TABLE live_matches (
    id SERIAL PRIMARY KEY,
    match_id INT NOT NULL,
    sport VARCHAR(50) NOT NULL,
    status VARCHAR(20) DEFAULT 'LIVE',
    team_a_score INT DEFAULT 0,
    team_b_score INT DEFAULT 0,
    viewers_online INT DEFAULT 0
);

-- Хронологія подій матчу
CREATE TABLE live_events (
    id SERIAL PRIMARY KEY,
    live_match_id INT REFERENCES live_matches(id),
    event_minute INT NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    player_id INT,
    team_id INT,
    description TEXT
);

-- Метадані подій
CREATE TABLE event_metadata (
    id SERIAL PRIMARY KEY,
    live_event_id INT REFERENCES live_events(id),
    attribute_key VARCHAR(50) NOT NULL,
    attribute_value VARCHAR(255) NOT NULL
);

-- ПРИКЛАД ВСТАВКИ ДАНИХ (Імітація одного гола):
INSERT INTO live_matches (match_id, sport, team_a_score, team_b_score, viewers_online) 
VALUES (501, 'Football', 2, 1, 45000);

-- Вставляємо подію
INSERT INTO live_events (live_match_id, event_minute, event_type, player_id, team_id, description)
VALUES (1, 14, 'GOAL', 105, 20, 'Неймовірний удар з-за меж штрафного!');

-- Вставляємо динамічні метадані до цієї події
INSERT INTO event_metadata (live_event_id, attribute_key, attribute_value) VALUES (1, 'assist_by', '102');
INSERT INTO event_metadata (live_event_id, attribute_key, attribute_value) VALUES (1, 'distance_meters', '22');

-- ПРИКЛАД ЧИТАННЯ
SELECT m.match_id, e.event_minute, e.event_type, md.attribute_key, md.attribute_value
FROM live_matches m
JOIN live_events e ON m.id = e.live_match_id
LEFT JOIN event_metadata md ON e.id = md.live_event_id
WHERE m.match_id = 501;