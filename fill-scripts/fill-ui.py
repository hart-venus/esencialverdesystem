import pyodbc
from faker import Faker

# constants for testing
n_people = 10
n_fleets = 10
n_producers = 10

n_countries = 10
n_ppc = 10 # provinces per country
n_cpp = 10 # cities per province
n_lpc = 10 # locations per city


# end constants

server = 'localhost'
database = 'esencialverdesystem'
username = 'sa'
password = 'Sven1234'
cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)

# people table : full_name
# fleets table : plate, capacity
# locations : city_id, name, coordinates, zipcode
# producers : name
# cities : province_id, name
# provinces : country_id, name
# countries : name

def cleanUp():
    cursor = cnxn.cursor()
    cursor.execute("DELETE FROM people")
    cursor.execute("DELETE FROM fleets")
    cursor.execute("DELETE FROM producers")
    cursor.execute("DELETE FROM locations")
    cursor.execute("DELETE FROM cities")
    cursor.execute("DELETE FROM provinces")
    cursor.execute("DELETE FROM region_areas")
    cursor.execute("DELETE FROM countries")

    cursor.commit()

def fill():
    cursor = cnxn.cursor()
    fake = Faker()
    people = [(fake.name(),) for i in range(n_people)]
    fleets = [(fake.license_plate(), fake.random_int(100, 500)) for i in range(n_fleets)]
    countries = [(fake.country(),) for i in range(n_countries)]
    producers = [(fake.company(),) for i in range(n_producers)]

    cursor.executemany("INSERT INTO people(full_name) VALUES (?)", people)
    cursor.executemany("INSERT INTO fleets(plate, capacity) VALUES (?, ?)", fleets)
    cursor.executemany("INSERT INTO countries(name) VALUES (?)", countries)
    cursor.executemany("INSERT INTO producers(name) VALUES (?)", producers)

    # get the ids of the countries
    cursor.execute("SELECT country_id FROM countries")
    countries_ids = cursor.fetchall()

    # provinces per country
    provinces = []
    for country_id in countries_ids:
        for i in range(n_ppc):
            provinces.append((country_id[0], fake.state()))

    cursor.executemany("INSERT INTO provinces(country_id, name) VALUES (?, ?)", provinces)

    # get the ids of the provinces
    cursor.execute("SELECT province_id FROM provinces")
    provinces_ids = cursor.fetchall()

    # cities per province
    cities = []
    for province_id in provinces_ids:
        for i in range(n_cpp):
            cities.append((province_id[0], fake.city()))

    cursor.executemany("INSERT INTO cities(province_id, name) VALUES (?, ?)", cities)

    # get the ids of the cities
    cursor.execute("SELECT city_id FROM cities")
    cities_ids = cursor.fetchall()

    # locations per city
    locations = []
    for city_id in cities_ids:
        for i in range(n_lpc):
            fakeCoord = "POINT(" + str(fake.latitude()) + " " + str(fake.longitude()) + ")"
            locations.append((city_id[0], fake.street_address(), fakeCoord, fake.zipcode()))

    cursor.executemany("INSERT INTO locations(city_id, name, coordinates, zipcode) VALUES (?, ?, ?, ?)", locations)

    cursor.commit()

if __name__ == '__main__':
    cleanUp()
    fill()
    cnxn.close()

