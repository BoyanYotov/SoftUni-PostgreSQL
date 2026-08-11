SELECT
    c.id AS driver_id,
    v.vehicle_type AS vehicle_type,
    CONCAT(c.first_name, ' ', c.last_name) AS driver_name
FROM 
  campers AS c
JOIN 
  vehicles AS v
ON 
  c.id = v.driver_id;
