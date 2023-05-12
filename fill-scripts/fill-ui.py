import pyodbc
from faker import Faker

# constants for testing
n_people = 10

# end constants

server = 'localhost'
database = 'esencialverdesystem'
username = 'sa'
password = 'Sven1234'
cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)

# people table : full_name
# insert random names for testing

def cleanUp():
    cursor = cnxn.cursor()
    cursor.execute("DELETE FROM people")
    cursor.commit()

def fill():
    cursor = cnxn.cursor()
    fake = Faker()
    people = [(fake.name(),) for i in range(n_people)]
    cursor.executemany("INSERT INTO people(full_name) VALUES (?)", people)
    cursor.commit()

if __name__ == '__main__':
    cleanUp()
    fill()
    cnxn.close()

