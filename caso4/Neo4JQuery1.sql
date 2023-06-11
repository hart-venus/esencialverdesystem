SELECT
    locations.name as location,
    locations.location_id as location_id,
    sum(weight) as total_kg_sent,
    cp_to.collection_point_id as collection_point_id,
    cp_to.name as collection_point
FROM
    collection_log
    JOIN recipient_log ON recipient_log.collection_log_id = collection_log.collection_log_id
    JOIN service_contracts ON service_contracts.service_contract_id = collection_log.service_contract_id
    JOIN producers ON producers.producer_id = service_contracts.producer_id
    JOIN collection_points cp_from ON cp_from.producer_id = producers.producer_id
    JOIN locations ON locations.location_id = cp_from.location_id
    JOIN collection_points cp_to ON cp_to.collection_point_id = collection_log.collection_point_id
WHERE
    recipient_log.movement_type_id = 1
    -- AND cp_to.is_dropoff = 1
GROUP BY
    locations.name, locations.location_id, cp_to.collection_point_id, cp_to.name
