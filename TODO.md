

# To-do
---
## Feedback del profesor
- [ ] Fletes no parece darme mayor información, no se sabe prácticamente nada , incluso no se sabe si es un vehículo o serán varios

- [ ] Los nombres de las tablas en algunos casos les están quedando muy grandes, mejor póngale un nombre más abtracto o conceptual
- [ ] La tabla processing no hace falta
- Es importante sabe que insumos reciclados o reutilizados sirven para fabricar los productos, pero sin embargo eso podría sobrar, porque lo que realmente nos interesa saber es dado un lote de productos producidos, saber los lotes de salidas de procesos que fueron usados para su fabricación, para con ello ubicar los contractos y porcentajes respectivos a ser repartidos
### Done
- [X] Carbonfootprint es info sensible
- [X] Su modelo no permite que un país tenga más de una moneda, salvo asignandolose a otra provincia lo cual estaría mal, o bien para meter colones tendrámos que meterlo 7 veces en esu modelo
- [X] No es multi idioma
- [X] No veo regiones
- [X] El whichparty tampoco hace falta, evitemos ese tipo de genericsids, eso me lo puede decir los FKs junto con el action
- [X] En companies el bit de islocal no parece tener sentido, i mean no debería diferenciarse no causa nada
- [X] La frecuencia  no puede ser un varchar, tienen que haber datos que permita a la base de datos estimar bien cuando van a suceder las cosas, un texto no nos sirve para eso
- [X?] El contract que tenga algún número
- [X?] Los recycle contracts son parte del contrato también, es un todo
- [X] Pongamosle marca el tipo de recipiente
- [X] Supongo que en general companyid puede ser null pues se refiere a la compañía que recoge el producto? O tienen alguna forma de sin importar la forma siempre exista un company
- [X] El weight supongo que aguanta nulo pues solamente en planta podrían estarlo pensando, en el action de entrega
- [X] Todo lo que son transacciones, logs etc que son archivos de alto crecimiento mejor que las llaves sean bigint
- [X] El certificate debería tener algún nombre y descripción
- [X] El cleanliness en recipientes no hace sentido, podrían tener un estado eso si
- [X] Los contratos porque a los certificados?
- [X] No tengan un cleanliness en el recipienteslog, más bien lo que cambia en el action y así pueden suceder mucho más cosas que solo decir si está limpio o no
- [X] Están haciendo lo que mencionamos en clase que iba a estar casi imposible y es planificar los recipientes que se van a usar en una recolección
- [X] El precio no va al service contract, es mucho más detallado
- [X] No tiene nada para repartir en caso de tener beneficiaros de mi exceso de contamientación
- [X] Company y producer son redundantes en collectionlog, dicha tabla es de info sensible
- [X] Contactinfo no está sirviendo de nada
    Esta mal la relación contactinfo y confactinfohascontactinfotypes
    Me suena que sobra una tabla y mas bien eso se resuelve en producerparents y peoplehavecontacinfo y así
## Nuevas cosas del caso #3
