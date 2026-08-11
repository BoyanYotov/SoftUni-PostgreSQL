SELECT
    employees.employee_id,
    concat(first_name, ' ', last_name) AS full_name,
    projects.project_id,
    projects.name
FROM
  employees
JOIN
  employees_projects
ON employees.employee_id = employees_projects.employee_id
JOIN
  projects
ON employees_projects.project_id = projects.project_id
WHERE
  projects.project_id = 1;
