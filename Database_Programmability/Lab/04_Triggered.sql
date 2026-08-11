CREATE TABLE deleted_employees(
    employee_id serial PRIMARY KEY,
    first_name varchar(20),
    last_name varchar(20),
    middle_name varchar(20),
    job_title varchar(50),
    department_id int,
    salary numeric(19,4));

CREATE OR REPLACE FUNCTION fn_deleted_employees()
RETURNS TRIGGER
AS
    $$
    BEGIN
        INSERT INTO deleted_employees(first_name, last_name, middle_name, job_title, department_id, salary)
        VALUES (old.first_name, old.last_name, old.middle_name, old.job_title,old.department_id, old.salary);
        RETURN NEW;
    END;
    $$
LANGUAGE plpgsql;

CREATE TRIGGER fn_deleted_employees_trigger
    AFTER DELETE ON employees
    FOR EACH ROW EXECUTE FUNCTION fn_deleted_employees();
