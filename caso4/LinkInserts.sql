INSERT INTO eventTypes (name)
VALUES
  ('Type 1'),
  ('Type 2'),
  ('Type 3'),
  ('Type 4'),
  ('Type 5'),
  ('Type 6'),
  ('Type 7'),
  ('Type 8'),
  ('Type 9'),
  ('Type 10');

-- Insert records into objectTypes table
INSERT INTO objectTypes (name)
VALUES
  ('Object Type 1'),
  ('Object Type 2'),
  ('Object Type 3'),
  ('Object Type 4'),
  ('Object Type 5'),
  ('Object Type 6'),
  ('Object Type 7'),
  ('Object Type 8'),
  ('Object Type 9'),
  ('Object Type 10');

-- Insert records into levels table
INSERT INTO levels (name)
VALUES
  ('error'),
  ('warning'),
  ('info');

-- Insert records into sources table
INSERT INTO sources (name)
VALUES
  ('Source 1'),
  ('Source 2'),
  ('Source 3'),
  ('Source 4'),
  ('Source 5'),
  ('Source 6'),
  ('Source 7'),
  ('Source 8'),
  ('Source 9'),
  ('Source 10');

INSERT INTO eventlog (level_id, eventdate, eventtype, source_id, checksum, username, referenceId1, referenceId2, value1, value2)
VALUES
  (1, '2023-06-01 10:00:00', 1, 1, 1, 'user1', 1, 2, 'Value 1', 'Value 2'),
  (2, '2023-06-01 11:00:00', 2, 2, 2, 'user2', 3, 4, 'Value 3', 'Value 4'),
  (3, '2023-06-01 12:00:00', 3, 3, 3, 'user3', 5, 6, 'Value 5', 'Value 6');