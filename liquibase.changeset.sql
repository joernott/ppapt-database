--liquibase formatted sql

--changeset joernott:1 failOnError=true

CREATE TABLE campaign (
  campaignid varchar(36) NOT NULL,
  name varchar(128) NOT NULL,
  startdate bigint NOT NULL,
  campaignday bigint NOT NULL,
  gameround int NOT NULL
);

ALTER TABLE campaign
  ADD PRIMARY KEY (campaignid);

CREATE TABLE characters (
  characterid varchar(36) NOT NULL,
  user varchar(128) NOT NULL,
  campaign varchar(36) NOT NULL,
  name varchar(128) NOT NULL,
  role int NOT NULL
);

ALTER TABLE characters
  ADD PRIMARY KEY (characterid),
  ADD KEY role (role),
  ADD KEY user (user),
  ADD KEY campaign (campaign);

CREATE TABLE role (
  roleid int NOT NULL,
  name varchar(32) NOT NULL
);

ALTER TABLE role
  ADD PRIMARY KEY (roleid);

CREATE TABLE user (
  email varchar(128) NOT NULL,
  username varchar(64) NOT NULL,
  password varchar(60) NOT NULL,
  locked boolean NOT NULL
);


ALTER TABLE user
  ADD PRIMARY KEY (email);


ALTER TABLE campaign
  ADD CONSTRAINT rel_campaign_characters FOREIGN KEY (campaignid) REFERENCES characters (campaign);

ALTER TABLE characters
  ADD CONSTRAINT rel_characters_role FOREIGN KEY (role) REFERENCES role (roleid);

ALTER TABLE user
  ADD CONSTRAINT rel_user_characters FOREIGN KEY (email) REFERENCES characters (user);
COMMIT;

--changeset joernott:2 failOnError=true

INSERT INTO role (roleid, name) VALUES
(0, 'Gamemaster'),
(1, 'Player'),
(2, 'Dead character'),
(3, 'Guest character');
