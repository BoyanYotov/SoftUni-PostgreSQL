CREATE TABLE IF NOT EXISTS owners (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS animal_types (
    id SERIAL PRIMARY KEY,
    animal_type VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS cages (
    id SERIAL PRIMARY KEY,
    animal_type_id INT NOT NULL
        REFERENCES animal_types(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    birthdate DATE NOT NULL,
    owner_id INT
        REFERENCES owners(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    animal_type_id INT NOT NULL
        REFERENCES animal_types(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS volunteers_departments (
    id              SERIAL PRIMARY KEY,
    department_name VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS volunteers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    address VARCHAR(50),
    animal_id INT
        REFERENCES animals(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    department_id INT NOT NULL
        REFERENCES volunteers_departments(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS animals_cages (
    cage_id INT NOT NULL
        REFERENCES cages(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    animal_id INT NOT NULL
        REFERENCES animals(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO volunteers(name, phone_number, address, animal_id, department_id)
VALUES ('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.',15,1),
       ('Dimitur Stoev','0877564223',NULL,42,4),
       ('Kalina Evtimova','0896321112','Silistra, 21 Breza str.',9,7),
       ('Stoyan Tomov','0898564100','Montana, 1 Bor str.',18,8),
       ('Boryana Mileva','0888112233',NULL,31,5);

INSERT INTO animals(name, birthdate, owner_id, animal_type_id)
VALUES ('Giraffe','2018-09-21',21,1),
       ('Harpy Eagle','2015-04-17',15,3),
       ('Hamadryas Baboon','2017-11-02',NULL,1),
       ('Tuatara','2021-06-30',2,4);

UPDATE animals
SET owner_id = (SELECT id FROM owners WHERE owners.name = 'Kaloqn Stoqnov')
WHERE owner_id IS NULL;

DELETE FROM volunteers_departments
WHERE department_name = 'Education program assistant';

SELECT
    name,
    phone_number,
    address,
    animal_id,
    department_id
FROM volunteers
ORDER BY name, animal_id, department_id;

SELECT
    name,
    at.animal_type,
    to_char(birthdate, 'DD.MM.YYYY') AS birthdate
    FROM animals AS a
JOIN animal_types AS AT
ON a.animal_type_id = at.id
ORDER BY name;

SELECT
    o.name,
    count(*) AS count_of_animals
FROM owners AS o
JOIN animals AS a
ON o.id = a.owner_id
GROUP BY o.name
ORDER BY count_of_animals DESC, name
LIMIT 5;

SELECT
    concat(o.name, ' - ', a.name) AS "owners - animals",
    phone_number,
    cage_id
FROM animals AS a
JOIN owners AS o
ON a.owner_id = o.id
JOIN animals_cages AS ac
ON ac.animal_id = a.id
WHEREwhere animal_type_id = 1
ORDER BY o.name, a.name DESC;

SELECT
    name,
    phone_number,
    substring(address,position('Sofia' in address) + 7) AS address
FROM volunteers
JOIN volunteers_departments
ON volunteers.department_id = volunteers_departments.id
WHERE department_id = (SELECT id FROM volunteers_departments WHERE department_name = 'Education program assistant') AND
      address ILIKE '%Sofia%'
ORDER BY name;

CREATE OR REPLACE FUNCTION fn_get_volunteers_count_from_department(searched_volunteers_department varchar(30))
RETURNS int
    AS
    $$
    DECLARE count_volunteers int;

    BEGIN
        SELECT
            COUNT(*) INTO count_volunteers
        FROM volunteers
        JOIN volunteers_departments
        ON volunteers.department_id = volunteers_departments.id
        WHERE volunteers_departments.department_name = searched_volunteers_department;
        RETURN count_volunteers;
    END;
    $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sp_animals_with_owners_or_not(IN animal_name varchar(30), OUT owner_name text)
AS
    $$

    BEGIN
        SELECT o.name INTO owner_name
        FROM owners AS o
        JOIN animals AS a
        ON o.id = a.owner_id
        WHERE a.name = animal_name;

        IF owner_name IS NULL THEN
            owner_name := 'For adoption';
        END IF;
        END;
    $$
LANGUAGE plpgsql;
