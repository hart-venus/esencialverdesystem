

// Load CSV data
LOAD CSV WITH HEADERS FROM 'file:///n4j1.csv' AS row
FIELDTERMINATOR ';'
MERGE (p:Producer {producer_id: row.producer_id})
  ON CREATE SET p.producer = row.producer, p.total_kg_sent = toFloat(row.total_kg_sent)
MERGE (c:Company {company_id: row.company_id})
  ON CREATE SET c.company = row.company
MERGE (p)-[:SENT {kgs: toFloat(row.total_kg_sent)}]->(c);
