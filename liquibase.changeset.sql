--liquibase formatted sql

--changeset joernott:1 failOnError=true

create table campaigns (
  campaign_id   varchar(36) not null,
  campaign_name varchar(128) not null,
  startdate     bigint not null,
  campaign_day  bigint not null,
  game_round    int not null
);

alter table campaigns add primary key (campaign_id);

create table characters (
  character_id   varchar(36) not null,
  character_user varchar(128) not null,
  campaign       varchar(36) not null,
  character_name varchar(128) not null,
  character_role int not null
);

alter table characters add primary key (character_id);
create index character_role ON characters(character_role);
create index character_user ON characters(character_user);
create index campaign ON characters(campaign);

create table roles (
  role_id   int not null,
  role_name varchar(32) not null
);

alter table roles add primary key (role_id);

create table users (
  email         varchar(128) not null,
  user_name     varchar(64) not null,
  user_password varchar(60) not null,
  user_locked   boolean not null
);


alter table users add primary key (email);


alter table characters
  add constraint rel_campaigns_characters foreign key (campaign) references campaigns (campaign_id) on update cascade on delete restrict;

alter table characters
  add constraint rel_characters_roles foreign key (character_role) references roles (role_id)  on update cascade on delete restrict;

alter table characters
  add constraint rel_users_characters foreign key (character_user) references users (email)  on update cascade on delete restrict;


--changeset joernott:2 failOnError=true

insert into roles (role_id, role_name) VALUES
(0, 'Gamemaster'),
(1, 'Player'),
(2, 'Dead character'),
(3, 'Guest character');

-- changeset joernott:3 failOnError=true

create table turns (
  campaign_id   varchar(36) not null,
  turn_id       int not null,
  game_round    int not null,
  duration      int not null
);

alter table turns add primary key (campaign_id, turn_id);

alter table campaigns drop column campaign_day;
  
alter table campaigns drop column game_round;

alter table turns
  add constraint rel_campaigns_turns foreign key (campaign_id) references campaigns (campaign_id) on update cascade on delete restrict;

create table actiontypes (
  actiontype_id int not null;
  actiontype_name varchar(32);
);

alter table actiontypes add primary key (actiontype_id);

insert into actiontypes (actiontypes_id, actiontypes_name) VALUES
(0, 'Income'),
(1, 'Population'),
(2, 'Function'),
(3, 'Leave Function'),
(4, 'Kingdom Alignment');



create table logs (
  entry_id      varchar(36) not null,
  campaign_id   varchar(36) not null,
  turn_id       int not null,
  action        varchar(255) not null,
  duration      int not null,
);
