from flask import Flask, render_template, request
import pyodbc
import pandas as pd

app = Flask(__name__)

def floatOrZero(x):
    try:
        return float(x)
    except ValueError:
        return 0.0

def IntOrZero(x):
    try:
        return int(x)
    except ValueError:
        return 0

@app.route('/', methods=['GET', 'POST'])
def index():

    errorStr = ""
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
            form_data.getlist('tipo_residuo_recolectar[]'),
            form_data.getlist('tipo_recipiente_entregar[]'),
            form_data.getlist('cantidad_recipientes[]')
        )
        # filter when cantidad_recipientes == "" remove it from the list
        entregas = filter(lambda x: x[2] != "", entregas)


        EntregasData = [
            (
                r[1],
                0.0, # Peso es nulo, lo mide el cliente
                r[0],
                2, # Accion de entregar
            ) for r in entregas for i in range(IntOrZero(r[2])) # for each recipient
        ]

        # create the TVPs
        TransportistaTVP = [(form_data['transportista'], form_data['camion'], form_data['lugar'])]
        RecipientTVP = RecolectasData + EntregasData

        # see if we can call the procedure
        try:
            cursor.execute("{CALL SP_RegistrarColeccion(?, ?)}", TransportistaTVP, RecipientTVP)
            conn.commit()
            errorStr = "-1"
        except pyodbc.Error as e:
            message = e.args[1]
            # [Microsoft sql ] [ error code ... ] - message
            # Extract the error message
            start_index = message.rfind(']') + 1
            end_index = message.find('-', start_index)
            message = message[start_index:end_index].strip()

            errorStr = f"Ha ocurrido un error: {message}"
            with open("error.log", "a") as f:
                f.write(f"{errorStr}\n")

    # Ejecutar las consultas
    cursor.execute('EXEC GetPeopleFullNames')
    names = cursor.fetchall()

    cursor.execute('EXEC GetFleetsPlates')
    plates = cursor.fetchall()

    cursor.execute("EXEC GetCollectionPointsNames")
    collection_points_names = cursor.fetchall()

    cursor.execute("EXEC GetTrashTypesNames")
    trash_types = cursor.fetchall()

    cursor.execute("EXEC GetRecipientTypesNames")
    recipient_types = cursor.fetchall()

    # Cerrar la conexión
    cursor.close()
    conn.close()

    # Renderizar la plantilla y pasar los datos
    return render_template('index.html', error=errorStr, names=names, recipient_types = recipient_types, trash_types=trash_types, fleets=plates, collection_points_names=collection_points_names)

if __name__ == '__main__':
    app.run(debug=True)
