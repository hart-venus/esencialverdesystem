-- a. consulta original

SELECT c.name AS company, r.name AS region
FROM companies AS c
JOIN companies_have_regions AS chr ON c.company_id = chr.company_id
JOIN regions AS r ON chr.region_id = r.region_id;

-- c. reescribir como CTE

WITH company_regions AS (
    SELECT c.name AS company, r.name AS region
    FROM companies AS c
    JOIN companies_have_regions AS chr ON c.company_id = chr.company_id
    JOIN regions AS r ON chr.region_id = r.region_id
)
SELECT * FROM company_regions;
