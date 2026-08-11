SELECT
    towns.town_id,
    name AS town_name,
    address_text
FROM
  addresses
JOIN
  towns
ON 
  addresses.town_id = towns.town_id
WHERE
  name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY
  town_id, address_id;
