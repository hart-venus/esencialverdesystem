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

    # Ejecutar la consulta
    cursor.execute('SELECT * FROM countries')
    rows = cursor.fetchall()

    # Cerrar la conexión
    cursor.close()
    conn.close()

    # Renderizar la plantilla y pasar los datos
    return render_template('index.html', rows=rows)

if __name__ == '__main__':
    app.run()
