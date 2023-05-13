from flask import Flask, render_template, request
import pyodbc
import pandas as pd

app = Flask(__name__)

def floatOrZero(x):
    try:
        return float(x)
    except ValueError:
        return 0.0

@app.route('/', methods=['GET', 'POST'])
def index():

    # Establecer la cadena de conexión
    server = 'localhost'
    database = 'esencialverdesystem'
    username = 'sa'
    password = 'Sven1234'
    conn_str = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};UID={username};PWD={password}'

    # Conectar a la base de datos
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()

    """
    TVP REFERENCE
        CREATE TYPE CollectorInfo AS TABLE
        (
            Nombre VARCHAR(255),
            Placa VARCHAR(255),
            Lugar VARCHAR(255)
        );

        CREATE TYPE RecipientLogInfo AS TABLE
        (
            TipoRecipiente VARCHAR(255),
            Peso DECIMAL(12, 4),
            TipoResiduo VARCHAR(255),
            Accion INT,
            RecipienteID INT NULL,
            TipoRecipienteID INT NULL,
            TipoResiduoID INT NULL
        );
    STORED PROCEDURE REFERENCE

    CREATE PROCEDURE [dbo].[SP_RegistrarColeccion]
	    @CollectorTVP CollectorInfo,
	    @RecipientLogTVP RecipientLogInfo
    AS
    ...
    """
    # Si se envía el formulario
    if request.method == 'POST':
        form_data = request.form

        # vincular [0] con [0], [1] con [1], etc.
        recolectas = zip(
            form_data.getlist('tipo_residuo[]'),
            form_data.getlist('tipo_recipiente_recolectar[]'),
            form_data.getlist('cantidad_residuos[]')
        )
        # filter when cantidad_residuos == "" remove it from the list
        recolectas = filter(lambda x: x[2] != "", recolectas)

        RecolectasData = [
            (
                r[1],
                floatOrZero(r[2]), # Peso
                r[0],
                1, # Accion de recolectar
            ) for r in recolectas
        ]

        entregas = zip(
            form_data.getlist('tipo_recipiente_entregar[]'),
            form_data.getlist('cantidad_recipientes[]')
        )
        # filter when cantidad_recipientes == "" remove it from the list
        entregas = filter(lambda x: x[1] != "", entregas)

        """
        EntregasData = [
            (
                r[0],
                int(r[1]),
                0,
                2,
            ) for r in entregas
        ]
        """
        # create the TVPs
        TransportistaTVP = [(form_data['transportista'], form_data['camion'], form_data['lugar'])]
        RecipientTVP = RecolectasData # + EntregasData

        with open("error.log", "w") as f:
            f.write(RecipientTVP.__str__() + "\n")
        # see if we can call the procedure
        try:
            cursor.execute("{CALL SP_RegistrarColeccion(?, ?)}", TransportistaTVP, RecipientTVP)
            conn.commit()
        except pyodbc.Error as e:
            sqlstate = e.args[0]
            message = e.args[1]
            err_str = f"An error occurred: {sqlstate} {message}"
            # save to file
            with open("error.log", "a") as f:
                f.write(err_str + "\n")



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
