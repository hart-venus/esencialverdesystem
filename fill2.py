import pyodbc
from faker import Faker

server = 'localhost'
database = 'esencialverdesystem'
username = 'sa'
password = 'Sven1234'
cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
fake = Faker()
cursor = cnxn.cursor()
# producers: name
producers = [(fake.company(),) for i in range(100)]
# 1. delete all data from table
cursor.execute("DELETE FROM producers")
print(producers)
# 2. insert new data
cursor.executemany("INSERT INTO producers VALUES (NULL, ?, NULL, NULL, NULL)", producers)
cnxn.commit()

# products: name, kgs_to_produce
products = [ (fake.company(), fake.random_int(1, 1000)) for i in range(1000)]
cursor.execute("DELETE FROM products")
cursor.executemany("INSERT INTO products VALUES (?, ?)", products)
cnxn.commit()

