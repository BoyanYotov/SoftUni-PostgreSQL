CREATE OR REPLACE FUNCTION fn_count_employees_by_town(town_name VARCHAR(20))
RETURNS int
AS
    $$
    DECLARE
      e_count int;

    BEGIN
    SELECT COUNT(employee_id) FROM employees
        JOIN 
          addresses 
          USING (address_id)
        JOIN towns 
          ON addresses.town_id = towns.town_id
        WHERE 
          towns.name = town_name
        INTO 
          e_count;
    RETURN e_count;
    END;
    $$

LANGUAGE plpgsql;
