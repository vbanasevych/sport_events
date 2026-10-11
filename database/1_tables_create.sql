-- 1. Таблиця ролей користувачів
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- 2. Таблиця користувачів системи
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    updated_by INT REFERENCES users(id),
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 3. Зв'язок користувачів та ролей (Many-to-Many)
CREATE TABLE user_roles (
    user_id INT REFERENCES users(id),
    role_id INT REFERENCES roles(id),
    PRIMARY KEY (user_id, role_id)
);

-- 4. Довідник видів спорту
CREATE TABLE sports (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 5. Локації для проведення подій
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    capacity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    updated_by INT REFERENCES users(id),
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 6. Організатори подій
CREATE TABLE organizers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20)
);

-- 7. Спортивні події (Турніри, чемпіонати)
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    sport_id INT REFERENCES sports(id),
    location_id INT REFERENCES locations(id),
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    status VARCHAR(50), -- Наприклад: PLANNED, ONGOING, COMPLETED
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    updated_by INT REFERENCES users(id),
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 8. Зв'язок подій та організаторів (Many-to-Many)
CREATE TABLE event_organizers (
    event_id INT REFERENCES events(id),
    organizer_id INT REFERENCES organizers(id),
    PRIMARY KEY (event_id, organizer_id)
);

-- 9. Команди
CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    coach_name VARCHAR(100),
    founded_year INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 10. Спортсмени
CREATE TABLE athletes (
    id SERIAL PRIMARY KEY,
    team_id INT REFERENCES teams(id), -- Може бути NULL для індивідуальних видів спорту
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10)
);

-- 11. Реєстрація на подію (Учасники події)
CREATE TABLE event_participants (
    event_id INT REFERENCES events(id),
    team_id INT REFERENCES teams(id),
    athlete_id INT REFERENCES athletes(id),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 12. Матчі / Етапи турніру
CREATE TABLE matches (
    id SERIAL PRIMARY KEY,
    event_id INT REFERENCES events(id),
    round VARCHAR(50), -- Фінал, Півфінал тощо
    match_time TIMESTAMP NOT NULL,
    location_id INT REFERENCES locations(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    updated_by INT REFERENCES users(id),
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 13. Результати матчу для кожної команди/спортсмена
CREATE TABLE match_participants (
    match_id INT REFERENCES matches(id),
    team_id INT REFERENCES teams(id),
    athlete_id INT REFERENCES athletes(id),
    score INT,
    is_winner BOOLEAN,
    PRIMARY KEY (match_id, team_id, athlete_id)
);

-- 14. Судді (Прив'язані до акаунтів користувачів)
CREATE TABLE judges (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    qualification_level VARCHAR(50),
    certification_date DATE
);

-- 15. Призначення суддів на матч
CREATE TABLE match_judges (
    match_id INT REFERENCES matches(id),
    judge_id INT REFERENCES judges(id),
    role VARCHAR(50), -- Головний суддя, лінійний тощо
    PRIMARY KEY (match_id, judge_id)
);

-- 16. Квитки на події
CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    event_id INT REFERENCES events(id),
    price DECIMAL(10, 2),
    seat_number VARCHAR(50),
    is_sold BOOLEAN DEFAULT FALSE,
    purchased_by INT REFERENCES users(id)
);