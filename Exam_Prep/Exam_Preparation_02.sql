CREATE TABLE addresses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(10) NOT NULL
);

CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL CHECK (age > 0),
    rating NUMERIC(2) DEFAULT 5.5
);

CREATE TABLE cars (
    id SERIAL PRIMARY KEY,
    make VARCHAR(20) NOT NULL,
    model VARCHAR(20),
    year INT NOT NULL DEFAULT 1 CHECK (year > 0),
    mileage INT DEFAULT 1 CHECK (mileage > 0),
    condition CHAR(1) NOT NULL,
    category_id INT NOT NULL REFERENCES categories(id)
);

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    from_address_id INT NOT NULL REFERENCES addresses(id),
    start TIMESTAMP NOT NULL,
    bill NUMERIC(10, 2) DEFAULT 10 CHECK (bill > 0),
    car_id INT NOT NULL REFERENCES cars(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    client_id INT NOT NULL REFERENCES clients(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE cars_drivers (
    car_id INT NOT NULL REFERENCES cars(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    driver_id INT NOT NULL REFERENCES drivers(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

INSERT INTO clients (full_name, phone_number)
SELECT
    CONCAT(first_name, ' ', last_name),
    CONCAT('(088) 9999', drivers.id * 2)
FROM drivers
WHERE drivers.id BETWEEN 10 AND 20;

UPDATE cars
SET condition = 'C'
WHERE
    (mileage >= 800000 OR mileage IS NULL)
    AND year <= 2010
    AND make <> 'Mercedes-Benz';

DELETE FROM clients
WHERE
    LENGTH(full_name) > 3
    AND id NOT IN (
        SELECT client_id
        FROM courses
    );

SELECT
    make,
    model,
    condition
FROM cars
ORDER BY id;

SELECT
    d.first_name,
    d.last_name,
    c.make,
    c.model,
    c.mileage
FROM drivers AS d
JOIN cars_drivers AS cd
    ON d.id = cd.driver_id
JOIN cars AS c
    ON cd.car_id = c.id
WHERE c.mileage IS NOT NULL
ORDER BY c.mileage DESC, d.first_name;

SELECT
    c.id AS car_id,
    c.make,
    c.mileage,
    COUNT(co.id) AS count_of_courses,
    ROUND(AVG(co.bill), 2) AS average_bill
FROM cars AS c
LEFT JOIN courses AS co
    ON c.id = co.car_id
GROUP BY
    c.id,
    c.make,
    c.mileage
HAVING COUNT(co.id) <> 2
ORDER BY
    COUNT(co.id) DESC,
    car_id;

SELECT
    cl.full_name,
    COUNT(co.client_id) AS courses_count,
    SUM(co.bill) AS total_bill
FROM clients AS cl
JOIN courses AS co
    ON cl.id = co.client_id
WHERE SUBSTRING(cl.full_name, 2, 1) = 'a'
GROUP BY cl.full_name
HAVING COUNT(co.client_id) > 1
ORDER BY cl.full_name;
