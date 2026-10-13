CREATE TABLE publishers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    address_id INT NOT NULL REFERENCES addresses(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    website VARCHAR(40),
    phone VARCHAR(20)
);

CREATE TABLE players_ranges (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    min_players INT NOT NULL CHECK (min_players > 0),
    max_players INT NOT NULL CHECK (max_players > 0)
);

CREATE TABLE creators (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    email VARCHAR(30) NOT NULL
);

CREATE TABLE board_games (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    release_year INT NOT NULL CHECK (release_year > 0),
    rating NUMERIC(2) NOT NULL,
    category_id INT NOT NULL REFERENCES categories(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    publisher_id INT NOT NULL REFERENCES publishers(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    players_range_id INT NOT NULL REFERENCES players_ranges(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE creators_board_games (
    creator_id INT NOT NULL REFERENCES creators(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    board_game_id INT NOT NULL REFERENCES board_games(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO board_games (
    name,
    release_year,
    rating,
    category_id,
    publisher_id,
    players_range_id
)
VALUES
    ('Deep Blue', 2019, 5.67, 1, 15, 7),
    ('Paris', 2016, 9.78, 7, 1, 5),
    ('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
    ('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
    ('One Small Step', 2019, 5.75, 5, 9, 2);

INSERT INTO publishers (
    name,
    address_id,
    website,
    phone
)
VALUES
    ('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
    ('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
    ('BattleBooks', 13, 'www.battlebooks.com', '+12345678907');

UPDATE players_ranges
SET max_players = max_players + 1
WHERE min_players = 2
    AND max_players = 2;

UPDATE board_games
SET name = CONCAT(name, ' V2')
WHERE release_year >= 2020;

SELECT
    name,
    rating
FROM board_games
ORDER BY release_year, name DESC;

SELECT
    bg.id,
    bg.name,
    bg.release_year,
    c.name
FROM board_games AS bg
JOIN categories AS c
    ON bg.category_id = c.id
WHERE c.name IN ('Strategy Games', 'Wargames')
ORDER BY bg.release_year DESC;

SELECT
    c.id,
    CONCAT(c.first_name, ' ', c.last_name) AS creator_name,
    c.email
FROM creators AS c
LEFT JOIN creators_board_games AS cbg
    ON c.id = cbg.creator_id
WHERE cbg.board_game_id IS NULL;

SELECT
    bg.name,
    bg.rating,
    c.name AS category_name
FROM board_games AS bg
FULL JOIN categories AS c
    ON bg.category_id = c.id
FULL JOIN players_ranges AS pr
    ON bg.players_range_id = pr.id
WHERE
        (bg.rating > 7.00 AND bg.name ILIKE '%a%')
    OR
        (bg.rating > 7.50
         AND pr.min_players >= 2
         AND pr.max_players <= 5)
ORDER BY bg.name, bg.rating DESC
LIMIT 5;

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    MAX(bg.rating) AS max_rating
FROM creators AS c
JOIN creators_board_games AS cbg
    ON c.id = cbg.creator_id
JOIN board_games AS bg
    ON cbg.board_game_id = bg.id
WHERE c.email LIKE '%.com'
GROUP BY
    full_name,
    c.email;

SELECT
    c.last_name,
    CEIL(AVG(bg.rating)) AS average_rating,
    p.name
FROM creators AS c
JOIN creators_board_games AS cbg
    ON c.id = cbg.creator_id
JOIN board_games AS bg
    ON cbg.board_game_id = bg.id
JOIN publishers AS p
    ON bg.publisher_id = p.id
GROUP BY
    c.last_name,
    p.name
HAVING p.name = 'Stonemaier Games'
ORDER BY average_rating DESC;

CREATE OR REPLACE FUNCTION fn_creator_with_board_games(
    first_name_creator VARCHAR(30)
)
RETURNS INT
AS
$$
DECLARE
    count_games INT;
BEGIN
    SELECT COUNT(*)
    INTO count_games
    FROM board_games AS bg
    JOIN creators_board_games AS cbg
        ON bg.id = cbg.board_game_id
    JOIN creators AS c
        ON cbg.creator_id = c.id
    WHERE c.first_name = first_name_creator;

    RETURN count_games;
END;
$$
LANGUAGE plpgsql;
