import app from './app';

import './database/connnection';

app.listen(app.get('port'));

console.log('server breteando', app.get('port'));