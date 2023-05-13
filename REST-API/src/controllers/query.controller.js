import { getConnection } from "../database/connnection";


export const getProducers = async (req, res) => {

    const pool = await getConnection();
    const result = await pool.request().query('SELECT * FROM producers');
    res.json(result.recordset);

};