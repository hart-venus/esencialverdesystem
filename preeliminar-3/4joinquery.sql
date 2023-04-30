-- select all people in companies_have_people
-- get contact info from people_have_contact_info_types' value field
-- get contact info type from people_have_contact_info_types' contact_info_type_id field

SELECT companies.name AS 'company name', people.person_id AS 'person',  contact_info_types.name AS 'type', people_have_contact_info_types.value
FROM companies_have_people
INNER JOIN people ON companies_have_people.person_id = people.person_id
INNER JOIN people_have_contact_info_types ON people.person_id = people_have_contact_info_types.person_id
INNER JOIN contact_info_types ON people_have_contact_info_types.contact_info_type_id = contact_info_types.contact_info_type_id
INNER JOIN companies ON companies_have_people.company_id = companies.company_id;
