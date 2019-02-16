--liquibase formatted sql

--changeset joernott:1 failOnError=true

CREATE TABLE `campaign` (
  `campaignid` varchar(36) NOT NULL,
  `name` varchar(128) NOT NULL,
  `startdate` bigint(20) UNSIGNED NOT NULL,
  `campaignday` bigint(20) UNSIGNED NOT NULL,
  `round` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `campaign`
  ADD PRIMARY KEY (`campaignid`);

CREATE TABLE `characters` (
  `characterid` varchar(36) NOT NULL,
  `user` varchar(128) NOT NULL,
  `campaign` varchar(36) NOT NULL,
  `name` varchar(128) NOT NULL,
  `role` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `characters`
  ADD PRIMARY KEY (`characterid`),
  ADD KEY `role` (`role`),
  ADD KEY `user` (`user`),
  ADD KEY `campaign` (`campaign`);

CREATE TABLE `role` (
  `roleid` int(10) UNSIGNED NOT NULL,
  `name` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

ALTER TABLE `role`
  ADD PRIMARY KEY (`roleid`);

CREATE TABLE `user` (
  `email` varchar(128) NOT NULL,
  `username` varchar(64) NOT NULL,
  `password` varchar(60) NOT NULL,
  `locked` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `user`
  ADD PRIMARY KEY (`email`);


ALTER TABLE `campaign`
  ADD CONSTRAINT `rel_campaign_characters` FOREIGN KEY (`campaignid`) REFERENCES `characters` (`campaign`);

ALTER TABLE `characters`
  ADD CONSTRAINT `rel_characters_role` FOREIGN KEY (`role`) REFERENCES `role` (`roleid`);

ALTER TABLE `user`
  ADD CONSTRAINT `rel_user_characters` FOREIGN KEY (`email`) REFERENCES `characters` (`user`);
COMMIT;

--changeset joernott:2 failOnError=true

INSERT INTO `role` (`roleid`, `name`) VALUES
(0, 'Gamemaster'),
(1, 'Player'),
(2, 'Dead character'),
(3, 'Guest character');
