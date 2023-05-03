import pyodbc
from faker import Faker

server = 'localhost'
database = 'esencialverdesystem'
username = 'sa'
password = 'Sven1234'
cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)

# companies : name, created_at, updated_at, active

companies = []
fake = Faker()
for i in range(1000):
    companies.append((fake.company(), fake.date(), fake.date(), 1))

cursor = cnxn.cursor()
# 1. delete all data from table
cursor.execute("DELETE FROM people_have_contact_info_types")
cursor.execute("DELETE FROM contact_info_types")
cursor.execute("DELETE FROM companies_have_people")
cursor.execute("DELETE FROM people")
cursor.execute("DELETE FROM companies")
# 2. insert new data
cursor.executemany("INSERT INTO companies VALUES (?, ?, ?, ?)", companies)

cnxn.commit()
cursor.close()

# people : person_id (just insert, no id)

cursor = cnxn.cursor()
# 1. delete all data from table

# 2. insert new data
for i in range(10000):
    cursor.execute("INSERT INTO people DEFAULT VALUES")

cnxn.commit()
cursor.close()

cursor = cnxn.cursor()
# companies_have_people : company_id, person_id
# 1. delete all data from table

# 2. insert new data
for i in range(1, 10001):
    cursor.execute("INSERT INTO companies_have_people VALUES (?, ?)", (min((i//10)+1, 1000), i))

cnxn.commit()
cursor.close()

# contact_info_types : name
cursor = cnxn.cursor()
# 1. delete all data from table
# 2. insert new data
contact_info_types = ["name", "email", "phone", "address", "website"]
for i in contact_info_types:
    cursor.execute("INSERT INTO contact_info_types VALUES (?)", i)
cnxn.commit()
cursor.close()

# people_have_contact_info_types : person_id, contact_info_type_id, value
cursor = cnxn.cursor()
# 2. insert new data
for i in range(1, 10001):
    cursor.execute("INSERT INTO people_have_contact_info_types VALUES (?, ?, ?)", (i, 1, fake.name()))
    cursor.execute("INSERT INTO people_have_contact_info_types VALUES (?, ?, ?)", (i, 2, fake.email()))
    cursor.execute("INSERT INTO people_have_contact_info_types VALUES (?, ?, ?)", (i, 3, fake.phone_number()))
    cursor.execute("INSERT INTO people_have_contact_info_types VALUES (?, ?, ?)", (i, 4, fake.address()))
    cursor.execute("INSERT INTO people_have_contact_info_types VALUES (?, ?, ?)", (i, 5, fake.url()))

cnxn.commit()
cursor.close()

cnxn.close()

