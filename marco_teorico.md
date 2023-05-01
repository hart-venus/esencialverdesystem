# Marco Teórico

## Vista Dinámica vs Vista Indexada
Encontramos una diferencia significativa entre las vistas indexadas y las dinámicas, con un rendimiento pasando de los 57 a los 17 microsegundos, cuya diferencia se acentúa conforme aumenta el número de registros en la tabla.

Las vistas indexadas son más rápidas que las vistas dinámicas porque las vistas indexadas tienen un índice asociado, lo que permite que las consultas sean optimizadas y ejecutadas más eficientemente. A continuación, se presentan algunas de las razones por las cuales las vistas indexadas son más rápidas que las vistas dinámicas:

1. El índice de la vista indexada es similar a un índice de una tabla, lo que permite que las consultas sean optimizadas y ejecutadas más rápidamente. La vista indexada se almacena en una tabla temporal y se indexa, lo que permite que SQL Server acceda a los datos más rápidamente. En cambio, las vistas dinámicas se ejecutan cada vez que se llama a la vista, lo que puede ser menos eficiente.

2. Las vistas indexadas almacenan datos en caché, lo que permite que las consultas sean ejecutadas más rápidamente. Cuando se accede a una vista indexada, SQL Server puede recuperar los datos de la vista directamente desde el índice, en lugar de tener que realizar una consulta a la tabla subyacente cada vez. En cambio, las vistas dinámicas siempre deben ejecutar la consulta subyacente cada vez que se accede a la vista.
