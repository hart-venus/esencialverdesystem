-- create a sources table
create table sources (
  source_id int not null IDENTITY(1,1),
  name varchar(20) not null,
  primary key (source_id)
);

-- create a levels table
create table levels (
  level_id int not null IDENTITY(1,1),
  name varchar(20) not null, -- 1=error, 2=warning, 3=info
  primary key (level_id),
);

-- create objectTypes table
create table objectTypes (
  objectType_id bigint not null IDENTITY(1,1),
  name varchar(20) not null,
  primary key (objectType_id),

);

-- create eventTypes table
create table eventTypes (
  eventType_id int not null IDENTITY(1,1),
  name varchar(20) not null,
  primary key (eventType_id),
);

-- create an event log table
create table eventlog (
  eventlog_id INT NOT NULL IDENTITY(1,1),
  level_id int not null, -- 1=error, 2=warning, 3=info
  eventdate datetime not null,
  eventtype int not null,
  source_id int not null,
  checksum varbinary(32) not null, -- checksum of the event data
  username varchar(20) not null,
  referenceId1 bigint not null,
  referenceId2 bigint not null,
  value1 varchar(60) not null,
  value2 varchar(60) not null,
  primary key (eventlog_id),
  FOREIGN KEY (source_id) REFERENCES sources(source_id),
  FOREIGN KEY (level_id) REFERENCES levels(level_id),
  FOREIGN KEY (referenceId1) REFERENCES objectTypes(objectType_id),
  FOREIGN KEY (referenceId2) REFERENCES objectTypes(objectType_id),
  FOREIGN KEY (eventtype) REFERENCES eventTypes(eventtype_id)
);

