import { getConnection } from "../database/connnection";


export const getProducers = async (req, res) => {

    const pool = await getConnection();
    const result = await pool.request().query('SELECT * FROM producers');

    console.log(result);

    res.json('getProducers');

};