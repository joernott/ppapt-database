--liquibase formatted sql

--changeset joernott:1 failOnError=true

CREATE TABLE campaigns (
  campaign_id   varchar(36) NOT NULL,
  campaign_name varchar(128) NOT NULL,
  startdate     bigint NOT NULL,
  campaign_day  bigint NOT NULL,
  game_round    int NOT NULL
);

ALTER TABLE campaigns ADD PRIMARY KEY (campaign_id);

CREATE TABLE characters (
  character_id   varchar(36) NOT NULL,
  character_user varchar(128) NOT NULL,
  campaign       varchar(36) NOT NULL,
  character_name varchar(128) NOT NULL,
  character_role int NOT NULL
);

ALTER TABLE characters ADD PRIMARY KEY (character_id);
CREATE INDEX character_role ON characters(character_role);
CREATE INDEX character_user ON characters(character_user);
CREATE INDEX campaign ON characters(campaign);

CREATE TABLE roles (
  role_id   int NOT NULL,
  role_name varchar(32) NOT NULL
);

ALTER TABLE roles ADD PRIMARY KEY (role_id);

CREATE TABLE users (
  email         varchar(128) NOT NULL,
  user_name     varchar(64) NOT NULL,
  user_password varchar(60) NOT NULL,
  user_locked   boolean NOT NULL
);


ALTER TABLE users ADD PRIMARY KEY (email);


ALTER TABLE campaigns
  ADD CONSTRAINT rel_campaigns_characters FOREIGN KEY (campaign_id) REFERENCES characters (campaign) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE characters
  ADD CONSTRAINT rel_characters_roles FOREIGN KEY (character_role) REFERENCES roles (role_id)  ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE users
  ADD CONSTRAINT rel_users_characters FOREIGN KEY (email) REFERENCES characters (character_user)  ON UPDATE CASCADE ON DELETE RESTRICT;


--changeset joernott:2 failOnError=true

INSERT INTO roles (role_id, role_name) VALUES
(0, 'Gamemaster'),
(1, 'Player'),
(2, 'Dead character'),
(3, 'Guest character');
