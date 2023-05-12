-----------------------------------------------------------
-- Author: Ariel Leyva
-- Fecha: 12-05-2023
-- Desc: Tablas de entrada para registrar las acciones de un recolector de basura
-----------------------------------------------------------

CREATE TYPE CollectorInfo AS TABLE
(
    Nombre VARCHAR(255),
    Placa VARCHAR(255),
    Lugar VARCHAR(255)
);

CREATE TYPE RecipientLogInfo AS TABLE
(
    TipoRecipiente VARCHAR(255),
    Peso DECIMAL(12, 4),
    TipoResiduo VARCHAR(255),
    Accion INT
);
