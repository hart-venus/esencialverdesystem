# To-do
---
## Feedback del profesor
- [ ] Fletes no parece darme mayor información, no se sabe prácticamente nada , incluso no se sabe si es un vehículo o serán varios
- [ ] Todo lo que son transacciones, logs etc que son archivos de alto crecimiento mejor que las llaves sean bigint
- [ ] Company y producer son redundantes en collecitonlog, dicha tabla es de info sensible
- [ ] No tengan un cleanliness en el recipienteslog, más bien lo que cambia en el action y así pueden suceder mucho más cosas que solo decir si está limpio o no
- [ ] El weight supongo que aguanta nulo pues solamente en planta podrían estarlo pensando, en el action de entrega
- [ ] El cleanliness en recipientes no hace sentido, podrían tener un estado eso si
- [ ] Pongamole marca el tipo de recipiente
- [ ] Están haciendo lo que mencionamos en clase que iba a estar casi imposible y es planificar los recipientes que se van a usar en una recolección
- [ ] Supongo que en general companyid puede ser null pues se refiere a la compañía que recoge el producto? O tienen alguna forma de sin importar la forma siempre exista un company
- [ ] La frecuencia  no puede ser un varchar, tienen que haber datos que permita a la base de datos estimar bien cuando van a suceder las cosas, un texto no nos sirve para eso
- [ ] El whichparty tampoco hace falta, evitemos ese tipo de genericsids, eso me lo puede decir los FKs junto con el action
- [ ] En companies el bit de islocal no parece tener sentido, i mean no debería diferenciarse no causa nada
- [ ] Contactinfo no está sirviendo de nada
- [ ] Esta mal la relación contactinfo y confactinfohascontactinfotypes
- [ ] Me suena que sobra una tabla y mas bien eso se resuelve en producerparents y peoplehavecontacinfo y así
- [ ] Carbonfootprint es info sensible
- [ ] El contract que tenga algún número
- [ ] El precio no va al service contract, es mucho más detallado
- [ ] Los contratos porque a los certificados?
- [ ] El certificate debería tener algún nombre y descripción
- [ ] Los nombres de las tablas en algunos casos les están quedando muy grandes, mejor póngale un nombre más abtracto o conceptual
- [ ] La tabla proessing no hace falta
- [ ] Los recycle contracts son parte del contrato también, es un todo
- [ ] Es importante sabe que insumos reciclados o reutilizados sirven para fabricar los productos, pero sin embargo eso podría sobrar, porque lo que realmente nos interesa saber es dado un lote de productos producidos, saber los lotes de salidas de procesos que fueron usados para su fabricación, para con ello ubicar los contractos y porcentajes respectivos a ser repartidos

- [ ] No tiene nada para repartir en caso de tener beneficiaros de mi exceso de contamientación
### Done
- [X] Su modelo no permite que un país tenga más de una moneda, salvo asignandolose a otra provincia lo cual estaría mal, o bien para meter colones tendrámos que meterlo 7 veces en esu modelo
- [X] No es multi idioma
- [X] No veo regiones

## Nuevas cosas del caso #3