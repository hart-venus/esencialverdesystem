LOAD CSV WITH HEADERS FROM 'file:///n4j0.csv' AS row
FIELDTERMINATOR ';'
MERGE (l:Location {location_id: row.location_id})
  ON CREATE SET l.location = row.location, l.total_kg_sent = toFloat(row.total_kg_sent)
MERGE (c:CollectionPoint {collection_point_id: row.collection_point_id})
  ON CREATE SET c.collection_point = row.collection_point
MERGE (l)-[:SENT {kgs: toFloat(row.total_kg_sent)}]->(c);
