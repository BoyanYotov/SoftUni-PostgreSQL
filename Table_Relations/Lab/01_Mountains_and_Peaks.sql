CREATE TABLE mountains(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE peaks(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL,
    name VARCHAR(50) NOT NULL,
    mountain_id INT NOT NULL,
                  CONSTRAINT fk_peaks_mountains
                  FOREIGN KEY (mountain_id)
                  REFERENCES mountains(id)
);
