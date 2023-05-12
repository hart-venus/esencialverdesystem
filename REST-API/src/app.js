import express from 'express';
import config from './config';

import queryRoutes from './routes/query.routes';

const app = express();

//settings

app.set('port', config.port || 3000);

app.use(queryRoutes);

export default app;


