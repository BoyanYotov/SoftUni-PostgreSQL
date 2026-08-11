SELECT
    department_id,
COUNT(employees)
FROM 
  employees
GROUP BY 
  department_id
ORDER BY 
  department_id;
