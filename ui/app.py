from flask import Flask, render_template, request
import pyodbc

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def index():

    # Si se envía el formulario
    if request.method == 'POST':
        form_data = request.form
        print(form_data)
    # Establecer la cadena de conexión
    server = 'localhost'
    database = 'esencialverdesystem'
    username = 'sa'
    password = 'Sven1234'
    conn_str = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'

    # Conectar a la base de datos
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    # Ejecutar las consultas
    cursor.execute('SELECT full_name FROM people')
    names = cursor.fetchall()
    cursor.execute('SELECT plate FROM fleets')
    plates = cursor.fetchall()
    cursor.execute("SELECT name FROM collection_points WHERE is_dropoff = 1 AND active = 1")
    collection_points_names = cursor.fetchall()

    cursor.execute("SELECT name FROM trash_types")
    trash_types = cursor.fetchall()

    cursor.execute("SELECT name FROM recipient_types")
    recipient_types = cursor.fetchall()

    # Cerrar la conexión
    cursor.close()
    conn.close()

    # Renderizar la plantilla y pasar los datos
    return render_template('index.html', names=names, recipient_types = recipient_types, trash_types=trash_types, fleets=plates, collection_points_names=collection_points_names)

if __name__ == '__main__':
    app.run(debug=True)
