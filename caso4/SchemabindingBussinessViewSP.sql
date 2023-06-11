IF OBJECT_ID('RecyclingView', 'V') IS NOT NULL
    DROP VIEW RecyclingView;

--Creacion del view
CREATE VIEW dbo.RecyclingView

AS
SELECT
    sc.service_contract_id,
    sc.producer_id,
    sc.start_date,
    sc.end_date,
    cl.collection_log_id,
    cl.collection_point_id,
    cl.datetime,
    cl.responsible_person_id,
    rc.recycling_contract_id,
    i.invoice_id,
    i.producer_id AS invoice_producer_id,
    i.invoice_number,
    i.invoice_date,
    i.invoice_due_date,
    t.transaction_id,
    t.transaction_date,
    p.payment_id,
    p.payment_date,
    p.producer_id AS payment_producer_id
FROM dbo.service_contracts sc
JOIN dbo.collection_log cl ON cl.service_contract_id = sc.service_contract_id
JOIN dbo.recycling_contracts rc ON rc.service_contract_id = sc.service_contract_id
JOIN dbo.invoices i ON i.producer_id = sc.producer_id
JOIN dbo.transactions t ON t.currency_id = i.currency_id
JOIN dbo.payments p ON p.producer_id = i.producer_id;

--Se añade el schemabinding al view
ALTER VIEW dbo.RecyclingView
WITH SCHEMABINDING
AS
SELECT
    sc.service_contract_id,
    sc.producer_id,
    sc.start_date,
    sc.end_date,
    cl.collection_log_id,
    cl.collection_point_id,
    cl.datetime,
    cl.responsible_person_id,
    rc.recycling_contract_id,
    i.invoice_id,
    i.producer_id AS invoice_producer_id,
    i.invoice_number,
    i.invoice_date,
    i.invoice_due_date,
    t.transaction_id,
    t.transaction_date,
    p.payment_id,
    p.payment_date,
    p.producer_id AS payment_producer_id
FROM dbo.service_contracts sc
JOIN dbo.collection_log cl ON cl.service_contract_id = sc.service_contract_id
JOIN dbo.recycling_contracts rc ON rc.service_contract_id = sc.service_contract_id
JOIN dbo.invoices i ON i.producer_id = sc.producer_id
JOIN dbo.transactions t ON t.currency_id = i.currency_id
JOIN dbo.payments p ON p.producer_id = i.producer_id;

-----------------------------------
--Alters para prueba de dependencia
ALTER TABLE payments
DROP COLUMN payment_date

ALTER TABLE payments
ADD payment_date DATETIME NOT NULL
-----------------------------------