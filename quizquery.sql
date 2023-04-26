-- Query to select all companies per full country
SELECT c.name AS company, co.name AS country
FROM companies AS c
INNER JOIN region_areas AS ra ON ra.region_id = chr.region_id
INNER JOIN countries AS co ON co.country_id = ra.country_id
INNER JOIN companies_have_regions AS chr ON chr.company_id = c.id
WHERE co.company_id = 1;
