import pyodbc
from faker import Faker
import random
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
# collection_points : location_id, name, producer_id, is_dropoff

def cleanUp():
    cursor = cnxn.cursor()
    cursor.execute("DELETE FROM collection_points")
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

    # get the ids of the locations
    cursor.execute("SELECT location_id FROM locations")
    locations_ids = cursor.fetchall()

    for producer_name in producers:
        # get a random location
        random_location = random.choice(locations)[1]
        # get that location id
        cursor.execute("SELECT location_id FROM locations WHERE name = ?", random_location)
        location_id = cursor.fetchone()[0]

        # get producer id from name
        cursor.execute("SELECT producer_id FROM producers WHERE name = ?", producer_name[0])
        producer_id = cursor.fetchone()[0]

        # collection_points : location_id, name, producer_id, is_dropoff

        collection_point = (location_id, random_location + " " + producer_name[0], producer_id, 1)
        cursor.execute("INSERT INTO collection_points(location_id, name, producer_id, is_dropoff) VALUES (?, ?, ?, ?)", collection_point)








    cursor.commit()

if __name__ == '__main__':
    cleanUp()
    fill()
    cnxn.close()

