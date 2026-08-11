SELECT
	first_name,
	last_name,
	EXTRACT('year' from born) AS year
FROM
	authors;
