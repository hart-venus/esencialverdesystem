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
# just insert the name, but explicitly specify the column name
cursor.executemany("INSERT INTO producers (name) VALUES (?)", producers)

cnxn.commit()

# products: name, kgs_to_produce
products = [ (fake.company(), fake.random_int(1, 1000)) for i in range(1000)]
cursor.execute("DELETE FROM products")
cursor.executemany("INSERT INTO products (name, kg_to_produce) VALUES (?, ?)", products)

# currencies: name, symbol
currencies = [ (fake.currency_name(), fake.currency_code()) for i in range(100)]
cursor.execute("DELETE FROM currencies")
cursor.executemany("INSERT INTO currencies (name, symbol) VALUES (?, ?)", currencies)

# carbon_footprint_log : producer_id, score (random between 1 and 100)
# get all producers
cursor.execute("SELECT producer_id FROM producers")
producers = cursor.fetchall()
carbon_footprint_log = [ (i[0], fake.random_int(1, 100)) for i in producers]
cursor.execute("DELETE FROM carbon_footprint_log")
cursor.executemany("INSERT INTO carbon_footprint_log (producer_id, score) VALUES (?, ?)", carbon_footprint_log)

# currencies_dollar_exchange_rate_log: currency_id, exchange_rate (random between 1 and 100)
# get all currencies
cursor.execute("SELECT currency_id FROM currencies")
currencies = cursor.fetchall()
currencies_dollar_exchange_rate_log = [ (i[0], fake.random_int(1, 100)) for i in currencies]
cursor.execute("DELETE FROM currencies_dollar_exchange_rate_log")
cursor.executemany("INSERT INTO currencies_dollar_exchange_rate_log (currency_id, exchange_rate) VALUES (?, ?)", currencies_dollar_exchange_rate_log)


cnxn.commit()

