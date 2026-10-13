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
