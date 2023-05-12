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
    cursor.execute("DELETE FROM recipient_types")
    cursor.execute("DELETE FROM recipient_models")
    cursor.execute("DELETE FROM recipient_brands")
    cursor.execute("DELETE FROM trash_types")
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

    tipos_de_basura = [
    "Latas de refrescos",
    "Botellas de plástico",
    "Envases de alimentos",
    "Papeles y cartones",
    "Bolsas de plástico",
    "Colillas de cigarrillos",
    "Envoltorios de caramelos",
    "Pilas y baterías",
    "Envases de vidrio",
    "Residuos electrónicos",
    "Neumáticos viejos",
    "Envases de aerosol",
    "Restos de comida",
    "Juguetes rotos",
    "Ropa vieja",
    "Pañales desechables",
    "Residuos de jardín",
    "Metales oxidados",
    "Cartuchos de tinta",
    "Papel de aluminio",
    "Productos químicos vencidos",
    "Escombros de construcción",
    "Envases de aceite",
    "Medicamentos caducados",
    "Electrodomésticos obsoletos",
    "Pinceles y brochas viejas",
    "Envases de productos químicos",
    "Botellas de vidrio rotas",
    "Cables y cables de alimentación",
    "Pilas de botón",
    "Envoltorios de plástico",
    "Desperdicios de jardín",
    "Botellas de aceite vacías",
    "Vehículos abandonados",
    "Equipos electrónicos viejos",
    "Restos de pintura y disolventes",
    "Carcasas de teléfonos móviles",
    "Bombillas y tubos fluorescentes",
    "Envases de pesticidas",
    "Cartón mojado o sucio",
    "Juguetes de plástico rotos",
    "Envases de productos de limpieza",
    "Ropa y textiles desgastados",
    "Productos de cuidado personal vencidos",
    "Muebles viejos o dañados"
    ]
    tipos_de_basura = [(tipo_de_basura, random.choice([1, 0])) for tipo_de_basura in tipos_de_basura]

    contenedores_de_basura = [('Grande',), ('Mediano',), ('Pequeño',), ('Reciclaje',), ('Orgánicos',), ('Compostable',), ('Peligrosos',), ('Premium',), ('Metálicos',), ('Plásticos',), ('Vidrio',), ('Aceites',), ('Baterías',), ('Electrónicos',), ('Radiactivos',), ('Neumáticos',), ('Textiles',), ('Escombros',), ('Madera',), ('Cartón',), ('Papel',), ('Basura Hospitalaria',), ('Basura Industrial',)]

    cursor = cnxn.cursor()
    fake = Faker()
    people = [(fake.name(),) for i in range(n_people)]
    fleets = [(fake.license_plate(), fake.random_int(100, 500)) for i in range(n_fleets)]
    countries = [(fake.country(),) for i in range(n_countries)]
    producers = [(fake.company(),) for i in range(n_producers)]
    recipient_brands = [(fake.company(),) for i in range(n_producers)]
    recipient_models = [(fake.company(),) for i in range(n_producers)]

    cursor.executemany("INSERT INTO recipient_brands(name) VALUES (?)", recipient_brands)
    cursor.executemany("INSERT INTO people(full_name) VALUES (?)", people)
    cursor.executemany("INSERT INTO fleets(plate, capacity) VALUES (?, ?)", fleets)
    cursor.executemany("INSERT INTO countries(name) VALUES (?)", countries)
    cursor.executemany("INSERT INTO producers(name) VALUES (?)", producers)
    cursor.executemany("INSERT INTO trash_types(name, is_recyclable) VALUES (?, ?)", tipos_de_basura)


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

    # get ids for recipient brands
    cursor.execute("SELECT recipient_brand_id FROM recipient_brands")
    recipient_brands_ids = cursor.fetchall()

    # for each recipient model, get a random recipient brand
    recipient_models = [(recipient_brand_id[0], fake.company(), random.randint(3, 50)) for recipient_brand_id in recipient_brands_ids]
    print(recipient_models)
    cursor.executemany("INSERT INTO recipient_models(brand_id, name, weight_capacity) VALUES (?, ?, ?)", recipient_models)
    cursor.commit()

    # get ids for recipient models
    cursor.execute("SELECT recipient_model_id FROM recipient_models")
    recipient_models_ids = cursor.fetchall()

    # for each recipient type, get a random recipient model
    contenedores_de_basura = [(contenedor_de_basura[0], random.choice(recipient_models_ids)[0]) for contenedor_de_basura in contenedores_de_basura]
    cursor.executemany("INSERT INTO recipient_types(name, recipient_model_id) VALUES (?, ?)", contenedores_de_basura)

if __name__ == '__main__':
    cleanUp()
    fill()
    cnxn.close()

