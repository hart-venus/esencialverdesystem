# To-do
---
## Nuevas cosas del caso #3
- [X] Rellenar base de datos
- [X] Hacer query de 4 joins
- [X] Revisar optimización vista dinámica vs indexada
- [X] Realizar MEGA QUERY
- [X] Crear stored procedure que tome como parametro TVP
- [ ] simplificar mediante CTE la consulta de norma (MEGA QUERY)
- [ ] norma de MEGA QUERY
- [ ] entregar repo de flyway, scripts de prueba y pdf
## GIGA QUERY
- joins (left/right)
- except/intersect (A-B y A∩B)

- aggregate functions (SUM, COUNT, AVG, etc)
- igualdades y desigualdades

- group by
- sort
- wheres primary y non primary
- for json (hace output de json) AUTO


## MEGA QUERY
-> select de ventas por producto

[ company 1 ] [ product 1 ] [ sale week 1 ]
[ company 1 ] [ product 1 ] [ sale week 2 ]

[ company 1 ] [ product 2 ] [ sale week 1 ]
[ company 1 ] [ product 2 ] [ sale week 2 ]

[ company 2 ] [ product 1 ] [ sale week 1 ]
[ company 2 ] [ product 1 ] [ sale week 2 ]

[ company 2 ] [ product 2 ] [ sale week 1 ]
[ company 2 ] [ product 2 ] [ sale week 2 ]

-> except/intersect:
    intersect: locations de x compañia
    except: locations de x compañia que no esten en y compañia
-> aggregate: suma sum(price * dolar)
-> group by: semana
-> sort: tiempo desc
-> wheres:
    tipo de basura usada para producir el producto
    costo de la venta no supere X

-> for json: auto
