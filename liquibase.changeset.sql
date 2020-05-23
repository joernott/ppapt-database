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

alter table campaigns modify campaign_id uuid;

alter table characters s modify character_id uuid;

alter table characters s modify character_id uuid;


-- changeset joernott:4 failOnError=true

create table turns (
  campaign_id   uuid not null,
  turn_id       int not null,
  game_round    int not null,
  duration      int not null
);

alter table turns add primary key (campaign_id, turn_id);

alter table campaigns drop column campaign_day;
  
alter table campaigns drop column game_round;

alter table turns
  add constraint rel_campaigns_turns foreign key (campaign_id) references campaigns (campaign_id) on update cascade on delete restrict;

create table kingdoms (
  kingdom_id   uuid not null,
  campaign_id  uuid not null,
  kingdom_name varchar(128) not null,
);

alter table kingdoms add primary key (kingdom_id);

alter table kingdoms
  add constraint rel_campaigns_kingdoms foreign key (campaign_id) references campaigns (campaign_id) on update cascade on delete restrict;

create table terrain_types(
  terrain_type_id          int not null,
  terrain_type_name        varchar(64) not null,
  terrain_type_description clob not null
);

alter table terrain_types add primary key (terrain_type_id);

create table hexes(
  campaign_id     uuid not null,
  hex_id          varchar(10) not null,
  terrain_type_id int not null,
  player_notes    clob,
  gm_notes        clob,
);

alter table hexess add primary key (campaign_id, hex_id);

alter table hexes
  add constraint rel_campaigns_hexes foreign key (campaign_id) references campaigns (campaign_id) on update cascade on delete restrict;

alter table hexes
  add constraint rel_terrain_types_hexes foreign key (terrain_type_id) references terrain_types (terrain_type_id) on update cascade on delete restrict;

create table government_roles(
  govrole_id   int not null,
  govrole_name varchar(64) not null,
  govrole_link varchar(255) not null
);

insert into government_roles(govrole_id, govrole_name, govrole_link) values
(0, '(none)',''),
(1, 'ruler','https://www.d20pfsrd.com/gamemastering/other-rules/kingdom-building/#TOC-Ruler');

create table action_types (
  actiontype_id   int not null;
  actiontype_name varchar(32);
);

alter table action_types add primary key (actiontype_id);

insert into action_types (actiontypes_id, actiontypes_name) VALUES
(0, 'Cancel'),
(1, 'Setup'),
(2, 'Income'),
(3, 'Population'),
(4, 'Government'),
(5, 'Construction'),
(6, 'Decrees');
(7, 'Events');

create table actions(
  action_id          uuid not null,
  actiontype_id      int not null,
  action_name        varchar(64) not null,
  action_description clob not null,
  icon_path          varchar(255) not null,
  govrole_id         int defaultvalue=0,
  experience         int defaultvalue=0,
  gold               float defaultvalue=0
  bp                 int defaultvalue=0,
  consumption_bp     int defaultvalue=0,
  loyalty            int defaultvalue=0,
  economy            int defaultvalue=0,
  stability          int defaultvalue=0,
  unrest             int defaultvalue=0,
);

alter table actions add primary key (action_id);

alter table actions
  add constraint rel_action_types_actions foreign key (actiontype_id) references action_types (actiontype_id) on update cascade on delete restrict;

alter table actions
  add constraint rel_govbernment_roles_actions foreign key (govrole_id) references government_roles (govrole_id) on update cascade on delete restrict;


create table logs (
  log_id        uuid not null,
  campaign_id   uuid not null,
  turn_id       int not null,
  action_id      uuid not null,
  hex_id        varchar(10) not null,
  character_id  uuid defaultvalue='',
  duration      int not null,
  cancel_log_id uuid defaultvalue='',
  notes         clob
);

alter table logs add primary key (log_id);

alter table logs
  add constraint rel_campaigns_logs foreign key (campaign_id) references campaigns (campaign_id) on update cascade on delete restrict;

alter table logs
  add constraint rel_turns_logs foreign key (campaign_id, turn_id) references turns (campaign_id, turn_id) on update cascade on delete restrict;

alter table logs
  add constraint rel_actions_logs foreign key (action_id) references actions (action_id) on update cascade on delete restrict;

alter table logs
  add constraint rel_hexes_logs foreign key (hex_id) references hexess (hex_id) on update cascade on delete restrict;

alter table logs
  add constraint rel_characters_logs foreign key (character_id) references characters (character_id) on update cascade on delete restrict;
