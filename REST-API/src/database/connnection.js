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

async function getConnection() {
    
    const pool = await sql.connect(dbSettings)
    const result = await pool.request().query("SELECT * FROM dbo.currencies")
    console.log(result);

}

getConnection();
