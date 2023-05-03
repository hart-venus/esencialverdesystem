import pyodbc
from faker import Faker
import random

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
cursor.execute("DELETE FROM sales")
cursor.execute("DELETE FROM carbon_footprint_log")
cursor.execute("DELETE FROM currencies_dollar_exchange_rate_log")
cursor.execute("DELETE FROM recycling_contracts")
cursor.execute("DELETE FROM service_contracts")

cursor.execute("DELETE FROM producers")
print(producers)
# 2. insert new data
# just insert the name, but explicitly specify the column name
cursor.executemany("INSERT INTO producers (name) VALUES (?)", producers)

cnxn.commit()



# products: name, kgs_to_produce
products = [ (fake.company(), fake.random_int(1, 1000)) for i in range(10)]
cursor.execute("DELETE FROM products")
cursor.executemany("INSERT INTO products (name, kg_to_produce) VALUES (?, ?)", products)

# currencies: name, symbol
currencies = [ (fake.currency_name(), fake.currency_code()) for i in range(100)]
cursor.execute("DELETE FROM currencies")
cursor.executemany("INSERT INTO currencies (name, symbol) VALUES (?, ?)", currencies)


# product_price_log : product_id, price, currency_id
# get all products
cursor.execute("SELECT product_id FROM products")
products = cursor.fetchall()
# get all currencies
cursor.execute("SELECT currency_id FROM currencies")
currencies = cursor.fetchall()

# insert random price, random currency for each product
product_price_log = [ (i[0], fake.random_int(1, 100), random.choice(currencies)[0]) for i in products]
cursor.executemany("INSERT INTO product_price_log (product_id, price, currency_id) VALUES (?, ?, ?)", product_price_log)



# carbon_footprint_log : producer_id, score (random between 1 and 100)
# get all producers
cursor.execute("SELECT producer_id FROM producers")
producers = cursor.fetchall()
carbon_footprint_log = [ (i[0], fake.random_int(1, 100)) for i in producers]

cursor.executemany("INSERT INTO carbon_footprint_log (producer_id, score) VALUES (?, ?)", carbon_footprint_log)

# currencies_dollar_exchange_rate_log: currency_id, exchange_rate (random between 1 and 100)
# get all currencies
cursor.execute("SELECT currency_id FROM currencies")
currencies = cursor.fetchall()
currencies_dollar_exchange_rate_log = [ (i[0], fake.random_int(1, 100)) for i in currencies]
cursor.executemany("INSERT INTO currencies_dollar_exchange_rate_log (currency_id, exchange_rate) VALUES (?, ?)", currencies_dollar_exchange_rate_log)

# service_contracts: producer_id, start_date, end_date
# get all producers
cursor.execute("SELECT producer_id FROM producers")
producers = cursor.fetchall()
service_contracts = [ (i[0], fake.date(), fake.date()) for i in producers]
cursor.executemany("INSERT INTO service_contracts (producer_id, start_date, end_date) VALUES (?, ?, ?)", service_contracts)

# recycling_contracts: valid_from, valid_to, service_contract_id
# get all service_contracts
cursor.execute("SELECT service_contract_id FROM service_contracts")
service_contracts = cursor.fetchall()
recycling_contracts = [ (fake.date(), fake.date(), i[0]) for i in service_contracts]
cursor.executemany("INSERT INTO recycling_contracts (valid_from, valid_to, service_contract_id) VALUES (?, ?, ?)", recycling_contracts)

# sales : product_id, recycling_contract_id
# get all products
cursor.execute("SELECT product_id FROM products")
products = cursor.fetchall()
# get all recycling_contracts
cursor.execute("SELECT recycling_contract_id FROM recycling_contracts")
recycling_contracts = cursor.fetchall()
sales = [ (i[0], j[0]) for i in products for j in recycling_contracts for k in range(100)]
cursor.executemany("INSERT INTO sales (product_id, recycling_contract_id) VALUES (?, ?)", sales)


cnxn.commit()

