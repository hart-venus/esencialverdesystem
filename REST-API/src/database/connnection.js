import sql from 'mssql';

const dbSettings = {
    user: 'sa',
    password: 'Sven1234',
    server: 'localhost',
    database: 'esencialverdesystem', 
    options: {
        encrypt: true,
        trustServerCertificate: true
    }
}

export async function getConnection() {
    try {
        const pool = await sql.connect(dbSettings);
        return pool;
    } catch (error) {
        console.log(error);
    }
}
