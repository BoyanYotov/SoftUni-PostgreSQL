SELECT
	REPLACE(title, 'The', '***')
FROM
	books
WHERE
	Substring(title,1,3) = 'The';
