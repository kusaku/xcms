set foreign_key_checks = 0;


-- TABLE blocks


DROP TABLE IF EXISTS `blocks`;

CREATE TABLE `blocks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_object` int(11) NOT NULL DEFAULT '0',
  `filename` varchar(64) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `filename` (`filename`),
  KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=cp1251;

-- TABLE content


DROP TABLE IF EXISTS `content`;

CREATE TABLE `content` (
  `id_obj` int(10) unsigned NOT NULL,
  `id_field` int(10) unsigned NOT NULL,
  `val_int` bigint(20) DEFAULT NULL,
  `val_float` float DEFAULT NULL,
  `val_varchar` varchar(255) DEFAULT NULL,
  `val_text` mediumtext,
  `val_rel_obj` int(10) unsigned DEFAULT NULL,
  `val_rel_elem` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_obj`,`id_field`),
  KEY `fk_content_objects` (`id_obj`),
  KEY `fk_content_fields` (`id_field`),
  KEY `fk_rel_object` (`val_rel_obj`),
  KEY `fk_rel_element` (`val_rel_elem`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- TABLE element_types


DROP TABLE IF EXISTS `element_types`;

CREATE TABLE `element_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module` varchar(45) NOT NULL,
  `controller` varchar(45) NOT NULL,
  `action` varchar(45) NOT NULL DEFAULT 'view',
  `title` varchar(255) DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT '0',
  `is_child` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`module`,`controller`,`action`),
  KEY `id_public` (`is_public`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=cp1251;

-- TABLE elements


DROP TABLE IF EXISTS `elements`;

CREATE TABLE `elements` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_parent` int(10) unsigned DEFAULT NULL,
  `id_type` int(10) unsigned NOT NULL,
  `id_obj` int(10) unsigned NOT NULL,
  `id_lang` int(10) unsigned NOT NULL,
  `id_tpl` int(10) unsigned DEFAULT NULL,
  `id_menu` int(10) unsigned DEFAULT NULL,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_deleted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_default` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `urlname` varchar(128) DEFAULT NULL,
  `updatetime` datetime DEFAULT NULL,
  `ord` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `urlname` (`urlname`),
  KEY `fk_elements_types` (`id_type`),
  KEY `fk_elements_languages` (`id_lang`),
  KEY `fk_elements_objects` (`id_obj`),
  KEY `fk_elements_templates` (`id_tpl`),
  KEY `is_default` (`is_default`),
  KEY `is_deleted` (`is_deleted`),
  KEY `is_active` (`is_active`),
  KEY `ord` (`ord`),
  KEY `updatetime` (`updatetime`),
  KEY `fk_element_parent` (`id_parent`),
  KEY `fk_element_menu` (`id_menu`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=cp1251;

-- TABLE field_groups


DROP TABLE IF EXISTS `field_groups`;

CREATE TABLE `field_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `id_obj_type` int(10) unsigned NOT NULL,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_locked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_visible` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `title` varchar(255) DEFAULT NULL,
  `ord` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ord` (`ord`),
  KEY `name` (`name`),
  KEY `is_active` (`is_active`),
  KEY `is_visible` (`is_visible`),
  KEY `is_locked` (`is_locked`),
  KEY `fk_field_groups_object_types` (`id_obj_type`)
) ENGINE=InnoDB AUTO_INCREMENT=229 DEFAULT CHARSET=cp1251;

-- TABLE field_types


DROP TABLE IF EXISTS `field_types`;

CREATE TABLE `field_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `is_virtual` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `title` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `is_virtual` (`is_virtual`)
) ENGINE=InnoDB AUTO_INCREMENT=114 DEFAULT CHARSET=cp1251;

-- TABLE fields


DROP TABLE IF EXISTS `fields`;

CREATE TABLE `fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `id_type` int(10) unsigned NOT NULL,
  `id_guide` int(10) unsigned DEFAULT NULL,
  `is_locked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_inheritable` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_public` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_required` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) DEFAULT NULL,
  `tip` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `is_locked` (`is_locked`),
  KEY `is_inheritable` (`is_inheritable`),
  KEY `is_public` (`is_public`),
  KEY `is_required` (`is_required`),
  KEY `fk_fields_guide` (`id_guide`),
  KEY `fk_fields_field_types` (`id_type`)
) ENGINE=InnoDB AUTO_INCREMENT=183 DEFAULT CHARSET=cp1251;

-- TABLE fields_controller


DROP TABLE IF EXISTS `fields_controller`;

CREATE TABLE `fields_controller` (
  `id_field` int(10) unsigned NOT NULL,
  `id_group` int(10) unsigned NOT NULL,
  `ord` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_group`,`id_field`),
  KEY `fk_fields_controller_fields` (`id_field`),
  KEY `fk_filelds_controller_field_groups` (`id_group`),
  KEY `ord` (`ord`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- TABLE languages


DROP TABLE IF EXISTS `languages`;

CREATE TABLE `languages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `is_default` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `prefix` varchar(16) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prefix` (`prefix`),
  KEY `title` (`title`),
  KEY `is_default` (`is_default`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=cp1251;

-- TABLE object_types


DROP TABLE IF EXISTS `object_types`;

CREATE TABLE `object_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_parent` int(10) unsigned DEFAULT NULL,
  `id_element_type` int(10) unsigned DEFAULT NULL,
  `is_locked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_guidable` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_public` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `is_public` (`is_public`),
  KEY `is_locked` (`is_locked`),
  KEY `is_guidable` (`is_guidable`),
  KEY `fk_object_types_element_types` (`id_element_type`),
  KEY `fk_object_type_parent` (`id_parent`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=cp1251;

-- TABLE objects


DROP TABLE IF EXISTS `objects`;

CREATE TABLE `objects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_type` int(10) unsigned NOT NULL,
  `is_locked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_objects_object_types` (`id_type`),
  KEY `name` (`title`),
  KEY `is_locked` (`is_locked`)
) ENGINE=InnoDB AUTO_INCREMENT=10199 DEFAULT CHARSET=cp1251;

-- TABLE permissions_elements


DROP TABLE IF EXISTS `permissions_elements`;

CREATE TABLE `permissions_elements` (
  `id_owner` int(10) unsigned NOT NULL,
  `id_element` int(10) unsigned NOT NULL,
  `mode` varchar(45) NOT NULL,
  `allow` int(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_owner`,`id_element`,`mode`),
  KEY `fk_permissions_elements_elements` (`id_element`),
  KEY `fk_permissions_elements_usergroup` (`id_owner`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- TABLE permissions_modules


DROP TABLE IF EXISTS `permissions_modules`;

CREATE TABLE `permissions_modules` (
  `id_owner` int(10) unsigned NOT NULL,
  `id_etype` int(10) unsigned NOT NULL,
  `mode` varchar(45) NOT NULL DEFAULT '',
  `allow` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_owner`,`id_etype`,`mode`),
  KEY `fk_permissions_modules_element_types` (`id_etype`),
  KEY `fk_permissions_modules_usergroup` (`id_owner`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- TABLE registry


DROP TABLE IF EXISTS `registry`;

CREATE TABLE `registry` (
  `var` varchar(48) NOT NULL,
  `val` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`var`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

-- TABLE shop_order_info


DROP TABLE IF EXISTS `shop_order_info`;

CREATE TABLE `shop_order_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_order` int(11) NOT NULL,
  `id_obj` int(11) NOT NULL,
  `id_element` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKshop_order131973` (`id_order`)
) ENGINE=MyISAM AUTO_INCREMENT=46 DEFAULT CHARSET=cp1251;

-- TABLE shop_orders


DROP TABLE IF EXISTS `shop_orders`;

CREATE TABLE `shop_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_obj` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=44 DEFAULT CHARSET=cp1251;

-- TABLE templates


DROP TABLE IF EXISTS `templates`;

CREATE TABLE `templates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_lang` int(10) unsigned NOT NULL,
  `is_default` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `filename` varchar(64) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `is_default` (`is_default`),
  KEY `filename` (`filename`),
  KEY `title` (`title`),
  KEY `fk_templates_languages` (`id_lang`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=cp1251;

-- TABLE users


DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `id_object` int(10) unsigned NOT NULL,
  `id_usergroup` int(10) unsigned NOT NULL,
  `is_active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `password` varchar(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_users_objects` (`id_object`),
  KEY `fk_users_usergroup` (`id_usergroup`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=cp1251;

-- TABLE views


DROP TABLE IF EXISTS `views`;

CREATE TABLE `views` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `id_etype` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_views_1` (`id_etype`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- DATA FOR TABLE blocks

INSERT INTO blocks(id,id_object,filename,title)	VALUES(1,14,1290093098,'Новости');

-- DATA FOR TABLE content

INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(5,148,NULL,NULL,'Забузякин',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(5,149,NULL,NULL,'dmitry.k@fabricasaitov.ru',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(5,154,NULL,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(5,168,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(1000,22,NULL,NULL,'main',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(1000,111,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10000,102,NULL,NULL,NULL,'<p>Повышение жизненных стандартов, не меняя концепции, изложенной выше, настроено позитивно. Побочный PR-эффект переворачивает SWOT-анализ, осознав маркетинг как часть производства. Бренд индуктивно определяет портрет потребителя, не считаясь с затратами. Таргетирование детерминирует направленный маркетинг, невзирая на действия конкурентов.</p>
<p>Итак, ясно, что бизнес-модель инновационна. Согласно&nbsp;ставшей уже классической работе Филипа Котлера, повышение жизненных стандартов экономит потребительский рынок, повышая конкуренцию. Несмотря на сложности, рекламное сообщество масштабирует рекламный блок, работая над проектом. Потребительский рынок стремительно восстанавливает контент, отвоевывая свою долю рынка.</p>
<p>Побочный PR-эффект обычно правомочен. Производство неверно концентрирует из ряда вон выходящий системный анализ, расширяя долю рынка. Диктат потребителя, пренебрегая деталями, ригиден как никогда. Презентация требовальна к креативу. Взаимодействие корпорации и клиента поразительно. Стратегический рыночный план,&nbsp;конечно, притягивает бренд, осознав маркетинг как часть производства.</p>
<!-- block(''новости'') -->
<p>sdfgdsfgsdgf</p>
<!-- block(''новости'',''last 5'') -->',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10004,130,NULL,NULL,'Свяпа',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10004,131,NULL,NULL,'kuku@mumu.ru',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10013,138,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10014,138,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10016,22,NULL,NULL,'catalog',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10016,111,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10017,138,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10018,120,NULL,NULL,NULL,'<p>Мы там были</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10018,138,NULL,NULL,'lightbox.phtml',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10019,132,NULL,NULL,'1288272249pd.jpeg',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10020,132,NULL,NULL,'1288272317ii.jpeg',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10021,132,NULL,NULL,'1288272337km.jpeg',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10022,138,NULL,NULL,0,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10027,102,NULL,NULL,NULL,'<p>dhfgdhgfh</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10028,102,NULL,NULL,NULL,'<p>sdf</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10033,120,NULL,NULL,NULL,'',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10034,102,NULL,NULL,NULL,'<p><iframe src="http://demo.demo.fabricasaitov.loc/" border="0"></iframe></p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10036,121,NULL,NULL,NULL,'<p>ertyertey</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10036,122,NULL,NULL,NULL,'<p>ryertyertye</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10037,121,NULL,NULL,NULL,'<p>ertyert</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10037,122,NULL,NULL,NULL,'<p>yert ert etrye tr</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10038,121,NULL,NULL,NULL,'<p>ппрправ вапр вап рв</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10038,122,NULL,NULL,NULL,'<p>прв апр в</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10041,102,NULL,NULL,NULL,'',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10041,104,NULL,NULL,'Регистрация',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10041,105,NULL,NULL,'Регистрация нового пользователя',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10043,121,NULL,NULL,NULL,'<p>Акция махакция</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10048,148,NULL,NULL,'qwe',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10048,149,NULL,NULL,'qwe@qw1e.ru',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10049,104,NULL,NULL,'Кукушечки',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10049,105,NULL,NULL,'Личный кабинет',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10050,148,NULL,NULL,'qweqwewewwww',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10050,149,NULL,NULL,'qwe@qwe.ru',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10055,150,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10055,151,NULL,NULL,'Бзденька',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10055,152,NULL,NULL,'1305532724qj.jpeg',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10055,153,NULL,NULL,NULL,'<p>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
Сеть кинотеатров &laquo;Монитор&raquo; и сеть Амбаров представляют: 17 мая во всех Амбарах &laquo;Пиратская вечеринка&raquo;, приуроченная событию года - открытию кинозала IMAX в киноплексе &laquo;Семь звёзд&raquo; в СБС Мегамолл!</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10056,104,NULL,NULL,'Крем для рук “HandCramUltra”',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10056,150,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10056,151,NULL,NULL,'Хренька',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10056,152,NULL,NULL,'1305532622eq.jpeg',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10056,153,NULL,NULL,NULL,'<p>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
Интенсивный защитный крем для рук Atrix с экстрактом ромашки образует защитный слой и предотвращает негативное воздействие окружающей среды. Одобрен дерматологами.</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10057,150,NULL,500,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10057,151,NULL,NULL,'Гнямба',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10057,152,NULL,NULL,'1305532609me.jpeg',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10057,153,NULL,NULL,NULL,'<p>описательное высказывание, дескриптивное высказывание (от англ. description описание) высказывание, главной функцией которого является описание действительности. Если О., даваемое высказыванием, соответствует реальному положению дел, высказывание &hellip;   Философская энциклопедия</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10058,102,NULL,NULL,NULL,'',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10064,156,3570,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10064,157,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10065,156,7168,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10065,157,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10066,156,94193,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10066,157,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10067,156,40594,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10067,157,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10068,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10068,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10069,156,46243,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10069,157,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10070,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10070,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10071,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10071,156,34570,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10071,157,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10072,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10072,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10072,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10073,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10073,156,51367,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10073,157,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10074,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10074,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10074,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10075,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10075,156,39395,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10075,157,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10076,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10076,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10076,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10077,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10077,156,37189,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10077,157,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10078,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10078,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10078,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10079,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10079,156,21283,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10079,157,NULL,300,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10080,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10080,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10080,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10081,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10081,156,69226,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10081,157,NULL,300,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10082,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10082,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10082,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10083,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10083,156,60239,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10083,157,NULL,300,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10084,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10084,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10084,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10085,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10085,156,11499,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10085,157,NULL,300,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10086,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10086,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10086,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10087,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10087,156,37952,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10087,157,NULL,300,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10088,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10088,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10088,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10089,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10089,156,53098,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10089,157,NULL,300,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10090,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10090,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10090,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10091,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10091,156,76868,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10091,157,NULL,300,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10092,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10092,156,89566,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10092,157,NULL,300,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10093,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10093,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10093,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10094,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10094,156,72577,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10094,157,NULL,300,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10095,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10095,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10095,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10096,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10096,156,36697,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10096,157,NULL,300,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10097,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10097,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10097,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10098,155,7,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10098,156,20276,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10098,157,NULL,650,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10099,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10099,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10099,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10100,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10100,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10100,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10102,164,NULL,NULL,'О-как!',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10107,167,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10108,167,NULL,NULL,'мсяывмым',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10110,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10110,156,5382,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10110,157,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10111,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10111,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10111,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10112,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10112,156,80290,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10112,157,NULL,300,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10113,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10113,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10113,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10114,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10114,156,42658,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10114,157,NULL,1200,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10115,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10115,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10115,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10116,159,42,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10116,160,NULL,500,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10116,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10117,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10117,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10117,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10118,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10118,156,33374,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10118,157,NULL,1450,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10119,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10119,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10119,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10120,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10120,156,48502,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10120,157,NULL,2350,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10121,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10121,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10121,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10122,159,42,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10122,160,NULL,500,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10122,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10123,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10123,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10123,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10124,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10124,156,6724,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10124,157,NULL,2500,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10125,159,40,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10125,160,NULL,150,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10125,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10126,104,NULL,NULL,'Гнямбочка',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10126,105,NULL,NULL,'Гнямбочка',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10126,150,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10126,152,NULL,NULL,'1305720591ic.jpeg',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10126,153,NULL,NULL,NULL,'<p>Ну просто суперская штука!!</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10127,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10127,156,14721,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10127,157,NULL,2253,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10127,172,NULL,NULL,NULL,'Комментарий, Комментарий, Комментарий.',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10128,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10128,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10128,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10129,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10129,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10129,161,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10130,148,NULL,NULL,'Кривчиков',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10130,149,NULL,NULL,'dmitry.k@fabricasaitov.ru',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10130,154,NULL,NULL,NULL,'пр. Б.Хмельницкого 73',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10130,168,NULL,NULL,'4722-312138',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10131,155,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10131,156,21419,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10131,157,NULL,2256,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10131,158,NULL,NULL,NULL,NULL,10062,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10131,170,NULL,NULL,NULL,NULL,10102,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10131,171,NULL,NULL,'ул. Горького 15 кв.43',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10131,172,NULL,NULL,NULL,'Хочу что-б доставили очень быстро!',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10131,176,NULL,NULL,'2011-05-16 19:12:35',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10132,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10132,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10132,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10133,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10133,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10133,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10134,155,10130,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10134,156,70168,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10134,157,NULL,2256,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10134,172,NULL,NULL,NULL,'dfgdgdfg',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10134,176,NULL,NULL,'2011-05-16 19:33:32',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10135,155,10130,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10135,156,9865,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10135,157,NULL,2256,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10135,172,NULL,NULL,NULL,'dfgdgdfg',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10135,176,NULL,NULL,'2011-05-16 19:33:55',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10136,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10136,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10136,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10137,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10137,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10137,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10138,148,NULL,NULL,'Зинин',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10138,149,NULL,NULL,'aaas@ya.ru',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10138,154,NULL,NULL,NULL,'пр.Славы 90 - 190',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10138,168,NULL,NULL,'+7-904-5556664',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10140,155,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10140,156,36498,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10140,157,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10140,158,NULL,NULL,NULL,NULL,10152,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10140,171,NULL,NULL,'ул.Мира 8',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10140,172,NULL,NULL,NULL,'Привезти на такси',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10140,176,NULL,NULL,'2011-05-17 11:55:32',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10141,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10141,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10141,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10142,155,10138,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10142,156,83150,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10142,157,NULL,1503,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10142,171,NULL,NULL,'пр.Славы 90 - 190',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10142,172,NULL,NULL,NULL,'К новому году!',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10142,176,NULL,NULL,'2011-05-17 12:08:56',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10142,177,NULL,NULL,'+7-904-5556664',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10143,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10143,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10143,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10144,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10144,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10144,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10145,155,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10145,156,16505,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10145,157,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10145,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10145,170,NULL,NULL,NULL,NULL,10104,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10145,171,NULL,NULL,'ул.Мира 8',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10145,172,NULL,NULL,NULL,'Гнямбу мне!',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10145,176,NULL,NULL,'2011-05-17 12:29:02',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10145,177,NULL,NULL,'+7-911-54545561',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10146,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10146,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10146,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10147,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10147,156,48893,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10147,157,NULL,3509,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10147,170,NULL,NULL,NULL,NULL,10103,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10147,171,NULL,NULL,'ул.Мира 9',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10147,176,NULL,NULL,'2011-05-17 14:58:23',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10147,177,NULL,NULL,'+7-911-54545561',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10148,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10148,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10148,161,3,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10149,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10149,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10149,161,2,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10150,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10150,156,28966,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10150,157,NULL,4012,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10150,158,NULL,NULL,NULL,NULL,10062,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10150,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10150,171,NULL,NULL,'ул.Мира 9',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10150,176,NULL,NULL,'2011-05-17 15:11:20',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10150,177,NULL,NULL,'+7-911-54545561',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10151,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10151,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10151,161,4,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10153,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10153,156,83001,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10153,157,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10153,158,NULL,NULL,NULL,NULL,10152,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10153,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10153,171,NULL,NULL,'ул.Мира 9',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10153,172,NULL,NULL,NULL,'Люблю ПОЧТУ РОССИИ',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10153,176,NULL,NULL,'2011-05-17 15:46:23',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10153,177,NULL,NULL,'+7-911-54545561',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10154,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10154,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10154,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10155,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10155,156,20244,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10155,157,NULL,4012,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10155,158,NULL,NULL,NULL,NULL,10062,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10155,170,NULL,NULL,NULL,NULL,10103,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10155,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10155,172,NULL,NULL,NULL,'Для Игоря',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10155,176,NULL,NULL,'2011-05-17 15:50:20',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10155,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10156,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10156,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10156,161,4,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10158,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10158,156,55403,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10158,157,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10158,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10158,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10158,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10158,172,NULL,NULL,NULL,'My Comment',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10158,176,NULL,NULL,'2011-05-18 10:13:36',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10158,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10159,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10159,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10159,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10160,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10160,156,5312,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10160,157,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10160,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10160,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10160,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10160,172,NULL,NULL,NULL,'asdfsf',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10160,176,NULL,NULL,'2011-05-18 10:25:58',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10160,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10161,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10161,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10161,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10162,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10162,156,1304,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10162,157,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10162,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10162,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10162,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10162,172,NULL,NULL,NULL,'asdad',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10162,176,NULL,NULL,'2011-05-18 10:32:42',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10162,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10163,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10163,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10163,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10164,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10164,156,21960,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10164,157,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10164,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10164,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10164,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10164,172,NULL,NULL,NULL,'asdasd',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10164,176,NULL,NULL,'2011-05-18 10:41:26',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10164,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10165,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10165,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10165,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10166,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10166,156,43702,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10166,157,NULL,3009,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10166,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10166,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10166,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10166,172,NULL,NULL,NULL,'sdgdsfg',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10166,176,NULL,NULL,'2011-05-18 11:22:59',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10166,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10167,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10167,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10167,161,3,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10168,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10168,156,32567,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10168,157,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10168,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10168,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10168,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10168,172,NULL,NULL,NULL,'gfzdgfd',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10168,176,NULL,NULL,'2011-05-18 11:25:16',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10168,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10169,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10169,156,35427,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10169,157,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10169,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10169,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10169,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10169,176,NULL,NULL,'2011-05-18 12:20:20',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10169,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10170,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10170,156,44823,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10170,157,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10170,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10170,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10170,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10170,176,NULL,NULL,'2011-05-18 12:20:41',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10170,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10171,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10171,156,53152,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10171,157,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10171,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10171,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10171,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10171,176,NULL,NULL,'2011-05-18 12:22:09',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10171,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10172,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10172,156,11444,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10172,157,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10172,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10172,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10172,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10172,172,NULL,NULL,NULL,'Описание!!',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10172,176,NULL,NULL,'2011-05-18 12:23:30',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10172,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10173,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10173,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10173,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10174,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10174,156,93425,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10174,157,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10174,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10174,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10174,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10174,172,NULL,NULL,NULL,'asdfasf',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10174,176,NULL,NULL,'2011-05-18 12:39:34',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10174,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10175,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10175,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10175,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10176,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10176,156,60204,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10176,157,NULL,1253,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10176,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10176,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10176,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10176,172,NULL,NULL,NULL,'fdgsgsdfg',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10176,176,NULL,NULL,'2011-05-18 12:41:34',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10176,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10177,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10177,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10177,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10178,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10178,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10178,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10179,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10179,156,29986,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10179,157,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10179,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10179,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10179,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10179,172,NULL,NULL,NULL,'wfewqef',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10179,176,NULL,NULL,'2011-05-18 12:43:01',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10179,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10180,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10180,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10180,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10181,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10181,156,68063,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10181,157,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10181,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10181,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10181,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10181,172,NULL,NULL,NULL,'wfewqef',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10181,176,NULL,NULL,'2011-05-18 12:44:16',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10181,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10182,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10182,156,27952,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10182,157,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10182,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10182,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10182,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10182,172,NULL,NULL,NULL,'wfewqef',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10182,176,NULL,NULL,'2011-05-18 12:45:25',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10182,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10183,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10183,156,30823,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10183,157,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10183,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10183,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10183,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10183,172,NULL,NULL,NULL,'wfewqef',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10183,176,NULL,NULL,'2011-05-18 12:46:23',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10183,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10184,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10184,156,6899,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10184,157,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10184,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10184,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10184,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10184,172,NULL,NULL,NULL,'wfewqef',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10184,176,NULL,NULL,'2011-05-18 12:50:16',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10184,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10185,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10185,156,50564,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10185,157,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10185,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10185,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10185,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10185,172,NULL,NULL,NULL,'wfewqef',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10185,176,NULL,NULL,'2011-05-18 12:51:39',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10185,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10186,155,5,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10186,156,13047,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10186,157,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10186,158,NULL,NULL,NULL,NULL,10061,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10186,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10186,171,NULL,NULL,'ул.Быборгская 15 ',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10186,172,NULL,NULL,NULL,'wfewqef',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10186,176,NULL,NULL,'2011-05-18 12:52:30',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10186,177,NULL,NULL,'+7-911-54541111',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10187,104,NULL,NULL,'Диван - трансформер',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10187,105,NULL,NULL,'Диван - трансформер',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10187,150,NULL,9600,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10187,152,NULL,NULL,'1305713323gh.jpeg',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10187,153,NULL,NULL,NULL,'<p>Сами дизайнеры, вроде задумывали такой диван-трансформер, как универсальное место для работы за ноутбуком, но я уверен возможностей и применений у такой мебели значительно больше. Да и такой диванчик может украсить любой интерьер. Сами дизайнеры, вроде задумывали такой диван-трансформер, как универсальное место для работы за ноутбуком, но я уверен возможностей и применений у такой мебели значительно больше. Да и такой диванчик может украсить любой интерьер. Сами дизайнеры, вроде задумывали такой диван-трансформер, как универсальное место для работы за ноутбуком, но я уверен возможностей и применений у такой мебели значительно больше. Да и такой диванчик может украсить любой интерьер.</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10188,104,NULL,NULL,'Нечто',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10188,105,NULL,NULL,'Нечто',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10188,150,NULL,3,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10188,152,NULL,NULL,'1305720876qb.jpeg',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10188,153,NULL,NULL,NULL,'<p>Нечто непонятное. Даже не знаю как это описать. Просто нечто.</p>',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10189,155,10130,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10189,156,20567,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10189,157,NULL,10603,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10189,158,NULL,NULL,NULL,NULL,10062,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10189,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10189,171,NULL,NULL,'пр. Б.Хмельницкого 73',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10189,172,NULL,NULL,NULL,'Комментарий',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10189,176,NULL,NULL,'2011-05-18 16:23:24',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10189,177,NULL,NULL,'4722-312138',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10190,159,46,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10190,160,NULL,1003,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10190,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10191,159,47,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10191,160,NULL,9600,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10191,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10192,155,0,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10192,156,95184,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10192,157,NULL,29050,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10192,158,NULL,NULL,NULL,NULL,10062,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10192,170,NULL,NULL,NULL,NULL,10105,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10192,171,NULL,NULL,'пр. Б.Хмельницкого 73',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10192,172,NULL,NULL,NULL,'Привет!',NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10192,176,NULL,NULL,'2011-05-18 17:57:24',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10192,177,NULL,NULL,'4722-312138',NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10193,159,47,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10193,160,NULL,9600,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10193,161,3,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10194,159,41,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10194,160,NULL,250,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10194,161,1,NULL,NULL,NULL,NULL,NULL);
INSERT INTO content(id_obj,id_field,val_int,val_float,val_varchar,val_text,val_rel_obj,val_rel_elem)	VALUES(10197,102,NULL,NULL,NULL,'<p>tset</p>',NULL,NULL);

-- DATA FOR TABLE element_types

INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(1,'admin','','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(2,'admin','auth','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(3,'admin','module','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(4,'admin','config','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(5,'users','back','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(6,'users','group','view','Группы пользователей',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(7,'users','user','view','Пользователи',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(8,'data','back','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(9,'data','otype','view','Типы данных',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(10,'data','group','view','Группы полей',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(11,'data','field','view','Поля',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(12,'menu','back','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(13,'menu','','view','Меню сайта',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(14,'templates','back','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(15,'templates','','view','Шаблоны',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(16,'content','back','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(17,'content','','view','Контент',1,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(24,'content','sitemap','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(25,'trash','back','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(26,'content','artic','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(27,'feedback','back','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(28,'feedback','','view','Обратная связь',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(29,'system','back','view','Система',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(30,'blocks','back','view','Блоки',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(31,'search','','view','',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(32,'search','back','view','Поиск',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(33,'articles','back','view',NULL,0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(34,'articles','category','view','Ленты статей',1,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(35,'articles','item','view','Статьи',1,1);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(36,'catalog','back','view',NULL,0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(37,'catalog','category','view','Категория каталога',1,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(38,'catalog','item','view','Элементы каталога',1,1);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(39,'catalog','search','view','Поиск по каталогу',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(40,'gallery','back','view',NULL,0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(41,'gallery','category','view','Категории галереи',1,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(42,'gallery','item','view','Элементы галереи',1,1);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(43,'news','back','view',NULL,0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(44,'news','category','view','Ленты новостей',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(45,'news','item','view','Новости',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(46,'users','','view','Вход_выход',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(47,'users','register','view','Регистрация',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(48,'offers','','view','Акции',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(49,'offers','back','view',NULL,0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(50,'users','profile','view','Профиль пользователя',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(51,'shop','item','view','Товар',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(52,'shop','category','view','Категория товаров',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(53,'shop','back','view',NULL,0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(54,'shop','order','view','Заказ',0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(55,'shop','orders','view',NULL,0,0);
INSERT INTO element_types(id,module,controller,action,title,is_public,is_child)	VALUES(56,'guides','back','view','Справочники',0,0);

-- DATA FOR TABLE elements

INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(1,NULL,17,10000,1,0,1000,1,0,1,'Главная','2011-06-06 18:18:07',2);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(2,NULL,31,10001,1,0,NULL,1,0,0,'Поиск','2010-03-19 00:00:00',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(5,NULL,28,10004,1,0,1000,1,0,0,'Контакты','2010-11-16 16:49:48',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(14,NULL,37,10013,1,NULL,10016,1,0,0,1288265827,'2010-10-28 17:17:35',2);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(16,NULL,39,10015,1,NULL,NULL,1,0,0,'найдено_в_каталоге',NULL,1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(17,NULL,41,10017,1,NULL,1000,0,0,0,1288272041,'2010-11-08 13:24:49',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(18,17,41,10018,1,NULL,NULL,1,0,0,1288272062,'2010-10-28 17:26:13',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(19,18,42,10019,1,NULL,NULL,1,0,0,1288272232,'2010-10-28 17:24:30',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(20,18,42,10020,1,NULL,NULL,1,0,0,1288272306,'2010-10-28 17:25:21',2);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(21,18,42,10021,1,NULL,NULL,1,0,0,1288272328,'2010-10-28 17:25:41',3);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(22,NULL,37,10022,1,NULL,10016,1,0,0,1288272919,'2010-11-10 13:20:07',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(23,NULL,24,10026,1,NULL,NULL,1,0,0,'sitemap','2010-11-08 16:55:16',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(24,1,17,10027,1,NULL,NULL,1,1,0,1289225343,'2011-01-31 16:19:22',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(25,1,17,10028,1,NULL,NULL,1,1,0,1289225369,'2011-01-31 16:19:25',2);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(28,NULL,44,10033,1,NULL,1000,1,0,0,'Новости','2011-06-06 16:27:46',2);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(29,NULL,17,10034,1,NULL,1000,1,0,0,1290067882,'2010-11-18 11:33:01',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(30,28,45,10036,1,NULL,NULL,1,0,0,1290093023,'2010-11-18 18:14:20',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(31,28,45,10037,1,NULL,NULL,1,0,0,1290093037,'2010-11-18 18:14:32',5);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(32,28,45,10038,1,NULL,NULL,1,0,0,1290093277,'2010-11-18 18:14:51',4);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(33,NULL,48,10043,1,NULL,NULL,1,0,0,1291387335,'2010-12-03 17:42:16',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(34,29,47,10041,1,NULL,1000,1,0,0,'Регистрация','2011-05-17 11:18:40',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(35,2,50,10049,1,NULL,1000,1,0,0,'Profile','2010-12-29 11:27:20',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(39,NULL,52,10054,1,NULL,1000,1,0,0,'Магазин','2011-05-14 15:56:43',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(40,NULL,51,10055,1,NULL,NULL,1,0,0,'Монитор','2011-05-16 11:58:47',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(41,39,51,10056,1,NULL,NULL,1,0,0,1294924171,'2011-05-16 11:57:06',3);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(42,22,51,10057,1,NULL,NULL,1,0,0,1294927350,'2011-05-16 11:59:46',2);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(43,NULL,54,10058,1,NULL,NULL,1,0,0,'shopcart','2011-05-12 16:45:54',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(44,22,38,10101,1,NULL,NULL,1,0,0,1304594686,'2011-05-05 15:24:51',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(45,NULL,44,10106,1,NULL,NULL,1,0,0,1305189580,'2011-05-12 12:39:54',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(46,39,51,10126,1,NULL,NULL,1,0,0,1305533319,'2011-05-18 16:09:54',2);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(47,39,51,10187,1,NULL,NULL,1,0,0,1305713250,'2011-05-18 14:08:52',4);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(48,39,51,10188,1,NULL,NULL,1,0,0,1305720863,'2011-05-18 16:15:33',5);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(49,NULL,17,10196,1,NULL,NULL,1,0,0,1307449420,'2011-06-07 16:24:01',3);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(50,NULL,17,10197,1,NULL,1000,1,0,0,'catalog','2011-06-08 17:04:14',4);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(51,NULL,52,10198,1,NULL,NULL,1,0,0,1307539184,'2011-06-08 17:19:55',5);

-- DATA FOR TABLE field_groups

INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(1,'usersgroup',1,1,0,1,'Группа пользователей',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(2,'user',2,1,0,1,'Пользователь',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(3,'menuset',10,1,0,1,'Меню',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(101,'common',4,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(102,'seo',4,1,0,0,'Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(103,'menu',4,1,0,0,'Настройки меню',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(104,'page',4,1,0,0,'Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(105,'permissions',4,1,1,0,'Права доступа',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(111,'common',5,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(112,'seo',5,1,0,0,'Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(113,'menu',5,1,0,0,'Настройки меню',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(114,'page',5,1,0,0,'Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(115,'permissions',5,1,0,0,'Права доступа',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(116,'common',6,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(117,'seo',6,1,0,0,'Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(118,'page',6,1,0,0,'Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(119,'permissions',6,1,1,0,'Права доступа',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(141,'common',11,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(142,'seo',11,1,0,0,'Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(143,'menu',11,1,0,0,'Настройки меню',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(144,'page',11,1,1,0,'Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(145,'permissions',11,1,1,0,'Права доступа',6);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(146,'feedback',11,1,0,0,'Настройки формы обратной связи',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(147,'common',12,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(148,'seo',12,1,0,0,'Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(149,'menu',12,1,0,0,'Настройки меню',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(150,'page',12,1,1,0,'Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(151,'permissions',12,1,1,0,'Права доступа',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(152,'common',13,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(153,'seo',13,1,1,0,'Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(154,'page',13,1,1,0,'Настройки страницы',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(155,'common',14,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(156,'photo',14,1,0,1,'Редактирование фотографий',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(157,'seo',14,1,0,0,'Настройки для поисковых систем',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(158,'menu',14,1,0,0,'Настройки меню',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(159,'page',14,1,1,0,'Настройки страницы',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(160,'permissions',14,1,1,0,'Права доступа',6);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(161,'common',15,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(162,'photo',15,1,0,1,'Редактирование фотографий',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(163,'seo',15,1,1,0,'Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(164,'page',15,1,1,0,'Настройки страницы',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(165,'common',16,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(166,'seo',16,1,0,0,'Настройки для поисковых систем',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(167,'page',16,1,1,0,'Настройки страницы',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(168,'permissions',16,1,1,0,'Права доступа',6);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(169,'common',17,1,0,1,'Редактирование содержимого категории галереи',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(170,'photo',17,1,0,0,'Редактирование изображения',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(171,'seo',17,1,0,0,'Настройки для поисковых систем',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(172,'menu',17,1,0,0,'Настройки меню',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(173,'page',17,1,1,0,'Настройки страницы',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(174,'permissions',17,1,1,0,'Права доступа',6);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(175,'common',18,1,0,1,'Редактирование содержимого элемента галереи',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(176,'photo',18,1,0,0,'Редактирование изображения',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(177,'seo',18,1,1,0,'Настройки для поисковых систем',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(178,'menu',18,1,0,0,'Настройки меню',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(179,'page',18,1,1,0,'Настройки страницы',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(180,'common',19,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(181,'seo',19,1,0,0,'Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(182,'menu',19,1,0,0,'Настройки меню',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(183,'page',19,1,1,0,'Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(184,'permissions',19,1,1,0,'Права доступа',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(185,'common',20,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(186,'seo',20,1,1,0,'Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(187,'page',20,1,1,0,'Настройки страницы',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(189,'page',26,1,0,1,'Настройки страницы',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(190,'common',26,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(191,'photo',26,1,0,1,'Редактирование изображения',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(192,'permissions',25,1,0,0,'Права доступа',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(193,'common',25,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(194,'seo',25,1,0,0,'Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(195,'menu',25,1,0,0,'Настройки меню',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(196,'page',25,1,0,0,'Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(197,'common',28,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(198,'seo',28,1,0,0,'Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(199,'menu',28,1,0,0,'Настройки меню',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(200,'page',28,1,0,0,'Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(201,'permissions',28,1,0,1,'Права доступа',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(202,'page',29,1,0,1,'Настройки страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(203,'shop_item',29,1,0,1,'Параметры товара',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(204,'page',30,1,0,1,'Свойства страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(205,'common',29,1,0,1,'Редактирование содержимого страницы	',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(206,'common',30,1,0,1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(207,'page',31,1,0,1,'Настройки страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(208,'common',31,1,0,1,'Общие настройки',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(209,'order_info',34,1,0,1,'Информация о заказе',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(210,'order_items',35,1,0,1,'Содержимое заказа',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(211,'cityes',36,1,0,1,'Города',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(223,'title',32,1,0,1,'Название типа доставки',0);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(226,'1554dcc532888d3eba43b50c06a5a7e9',55,1,0,1,'FieldGroup1554dcc532888d3eba43b50c06a5a7e9',0);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(227,'7244e3e2ad513c220e53ff76adc1e605',56,1,0,1,'ФИО',0);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(228,'281af8fa3c3060a396ec8d6683bdc95f',57,1,0,1,'FieldGroup281af8fa3c3060a396ec8d6683bdc95f',0);

-- DATA FOR TABLE field_types

INSERT INTO field_types(id,name,is_virtual,title)	VALUES(1,'Boolean',0,'Флаг');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(2,'Integer',0,'Целое');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(3,'Float',0,'Число с точкой');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(4,'String',0,'Строка');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(5,'Text',0,'Текст');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(6,'Select',0,'Список');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(7,'MultiSelect',0,'Список с множественным выбором');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(8,'MultiCheckbox',0,'Группа флагов');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(9,'Radio',0,'Переключатель');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(10,'File',0,'Файл');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(11,'Date',0,'Дата');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(12,'HtmlText',0,'Текстовое поле с визуальным редактором');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(13,'Email',0,'Адрес электронной почты');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(14,'Photo',0,'Фотография');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(100,'Name',1,'Название');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(101,'Urlname',1,'Псевдостатический адрес');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(102,'ObjType',1,'Тип данных');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(103,'Template',1,'Шаблон');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(104,'Menu',1,'Меню');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(105,'Active',1,'Активность');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(106,'DefaultPage',1,'Страница по-умолчанию');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(107,'ElementPermissions',1,'Права доступа на элемент');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(108,'ModulePermissions',1,'Права доступа на модуль');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(109,'UserLogin',1,'Логин пользователя');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(110,'UserGroup',1,'Группа пользователей');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(111,'UserPassword',1,'Пароль пользователя');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(112,'TemplateView',0,'Шаблон вида');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(113,'GuideTitle',1,'Название элемента справочника');

-- DATA FOR TABLE fields

INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(1,'name',100,0,1,0,1,1,'Название страницы','Короткое название страницы. Отображается в меню и в заголовке содержимого страницы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(9,'user_groupname',100,0,1,0,1,1,'Название','Короткое название группы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(10,'user_name',100,0,1,0,1,1,'Имя','Короткое название пользователя');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(11,'login',109,0,1,0,1,1,'Логин','Логин пользователя');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(12,'user_group',110,1,1,0,1,1,'Группа','Группа пользователей, к которой принадлежит пользователь');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(13,'user_password',111,0,1,0,1,1,'Пароль','Здесь можно сменить пароль пользователя');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(14,'user_active',105,0,1,0,1,0,'Активирован','Активировать или блокировать пользователя');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(20,'menu_name',100,0,1,0,1,1,'Название блока меню','Короткое название меню');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(21,'menu_rooturl',4,0,1,0,1,0,'Ссылка','URL корневого элемента для навигации');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(22,'menu_class',4,0,1,0,1,0,'Название класса CSS','Класс CSS для стилизации вывода меню');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(102,'text',12,0,1,0,1,0,'Редактирование содержимого страницы','Используется для редактирования содержимого страницы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(103,'urlname',101,0,1,0,1,1,'Адрес страницы','Адрес страницы отображаемый в браузерной строке');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(104,'title',4,0,1,0,1,0,'Заголовок (Title)','Текст отображаемый в Мета-тегах TITLE страницы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(105,'title_text',4,0,1,0,1,0,'Заголовок страницы','Текст отображаемый в тегах заголовка (H1-H6)');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(106,'meta_keywords',4,0,1,0,1,0,'Ключевые слова (Keywords)','Текст отображаемый в Мета-тегах KEYWORDS страницы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(107,'meta_description',4,0,1,0,1,0,'Описание (Description)','Текст отображаемый в Мета-тегах DESCRIPTION страницы ');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(108,'no_index',1,0,1,0,0,0,'Индексация поисковиками','Запретить индексацию поисковиками');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(109,'menu_sel',104,10,1,1,1,0,'Выбрать меню','Выбирите в каком меню должна отображаться эта страница');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(110,'menu_showsub',1,0,1,0,1,0,'Показывать подменю','Управление отображением подменю');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(111,'menu_collapsed',1,0,1,0,1,0,'Свернуть подменю','Управление отображением подменю');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(112,'menu_img_title',10,0,1,0,1,0,'Изображение заголовка','Изображение для заголовка');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(113,'menu_img_unactive',10,0,1,0,1,0,'Изображение неактивного элемента','Изображение для неактивного элемента меню');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(114,'menu_img_active',10,0,1,0,1,0,'Изображение активного элемента','Изображение для активного элемента меню');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(115,'datatype',102,0,1,0,1,1,'Тип данных','Используемый тип данных');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(116,'template',103,0,1,0,1,1,'Шаблон','Используемый шаблон страницы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(117,'publish',105,0,1,0,1,0,'Опубликовать/скрыть','Для того чтобы скрыть страницу на сайте уберите отметку');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(118,'publish_date_to',11,0,1,0,1,0,'До','Дата снятия с публикации');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(119,'default',106,0,1,0,1,0,'Главная','Для того чтобы сделать эту страницу главной поставьте отметку');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(120,'description',12,0,1,0,1,0,'Описание','Текстовое описание');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(121,'news_preview',12,0,1,0,1,0,'Анонс','Анонс новости');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(122,'news_maintext',12,0,1,0,1,0,'Текст','Основной текст новости');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(123,'publish_arch',1,0,1,0,1,0,'Архив','Перевести в архив');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(124,'publish_date_from',11,0,1,0,1,0,'Дата публикации','Дата публикации');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(125,'publish_date_arch',11,0,1,0,0,0,'В архив','Дата перевода в архив');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(126,'publish_src_text',4,0,1,0,1,0,'Источник','Текст ссылки на источник');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(127,'publish_src_link',4,0,1,0,1,0,'URL источника','URL ссылки на источник');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(128,'permissions_elements',107,1,1,0,0,0,'Привилегии','Установите права доступа на эту страницу');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(129,'permissions_modules',108,0,1,0,0,0,'Права группы пользователей','Пользователи этой группы имеют нижеуказанные права');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(130,'feedback_subject',4,0,1,0,1,0,'Тема сообщения','Тема сообщения для отправляемых писем');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(131,'feedback_email',13,0,1,0,1,0,'E-mail','Адрес почтового ящика для получения отзывов');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(132,'element_photo',14,0,1,0,1,0,'Изображение','Основное изображение данного элемента');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(133,'catalog_item_preview',12,0,1,0,1,0,'Краткое описание','Краткое описание товара');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(134,'catalog_item_maintext',12,0,1,0,1,0,'Текст','Основной текст товара');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(135,'catalog_item_price',3,0,1,0,1,0,'Цена','Цена товара');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(138,'catalog_view',112,0,1,0,1,1,'Шаблон вида','Шаблон вида');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(139,'articles_preview',12,0,1,0,1,0,'Анонс','Анонс статьи');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(140,'articles_maintext',12,0,1,0,1,0,'Текст','Основной текст статьи');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(141,'gallery_item_preview',5,0,1,0,1,0,'Краткое описание','Краткое описание изображения');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(143,'news_image',14,NULL,0,0,1,0,'Изображение','Изображение');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(148,'user_surname',4,NULL,0,0,1,0,'Фамилия','Фамилия');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(149,'user_email',13,NULL,0,0,1,1,'Email','Email пользователя');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(150,'shop_item_price',3,NULL,0,0,1,0,'Цена товара','Цена за единицу товара');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(151,'shop_item_name',4,NULL,0,0,1,1,'Наименование','Название товара');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(152,'shop_item_image',14,NULL,0,0,1,0,'Изображение','Картинка');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(153,'shop_item_about',12,NULL,0,0,1,0,'Описание','Полное описание товара');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(154,'user_address',5,NULL,0,0,1,0,'Адрес','Адрес доставки');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(155,'shop_order_userid',2,2,0,0,1,1,'Пользователь',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(156,'shop_order_number',2,NULL,0,0,1,1,'№ заказа',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(157,'shop_order_sum',3,NULL,0,0,1,1,'Сумма заказа',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(158,'shop_order_delivery',6,32,0,0,1,0,'Способ доставки',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(159,'shop_order_itemid',2,29,0,0,1,0,'id товара',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(160,'shop_order_item_price',3,NULL,0,0,1,0,'Цена товара',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(161,'shop_order_item_count',2,NULL,0,0,1,0,'Количество',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(164,'city_name',113,NULL,0,0,1,1,'Название города','В это поле вы должны вписать название города');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(165,'12112312423432',4,NULL,0,0,1,0,'фыв',1);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(166,'asd',4,NULL,0,0,1,0,'sdas',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(167,123123,113,NULL,0,0,1,0,'Название и цена','Пример &quot;Самовывоз:100&quot;');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(168,'user_phone',4,NULL,0,0,1,0,'Телефон','Номер телефона');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(169,'user_state',6,36,0,0,1,0,'Город',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(170,'shop_order_city',6,36,0,0,1,1,'Город доставки','Город, в который требуется произвести доставку');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(171,'shop_order_address',4,NULL,0,0,1,1,'Адрес доставки','Подробный адрес');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(172,'shop_order_comment',5,NULL,0,0,1,0,'Комментарий к заказу','Комментарий');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(173,'shop_order_payment',6,NULL,0,0,1,0,'Способ оплаты',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(176,'shop_order_date',4,NULL,0,0,1,1,'Дата заказа',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(177,'shop_order_phone',4,NULL,0,0,1,0,'Контактный телефон',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(178,'sender_name',100,NULL,0,0,1,1,'ФИО','Ваше имя и фамилия');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(179,'sender_email',13,NULL,0,0,1,1,'E-mail','Укажите Ваш e-mail');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(180,'message_title',4,NULL,0,0,1,0,'Тема сообщения',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(181,'message_text',5,NULL,0,0,1,1,'Текст сообщения',NULL);
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(182,'qwe',113,NULL,0,0,1,0,'йцу',NULL);

-- DATA FOR TABLE fields_controller

INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(9,1,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(14,2,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(20,3,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(22,3,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(111,3,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,101,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,102,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(109,103,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,104,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,105,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,111,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,112,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(109,113,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,114,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,115,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,116,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,117,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,118,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,141,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,142,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(109,143,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,144,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,145,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(130,146,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,147,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,148,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(109,149,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,150,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,151,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,152,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,153,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,154,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,155,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(132,156,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,157,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(109,158,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,159,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,160,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,161,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(132,162,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,163,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,164,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,165,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,166,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,167,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,168,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,169,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(132,170,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,171,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(109,172,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,173,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,174,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,175,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(132,176,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,177,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(109,178,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,179,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,180,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,181,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(109,182,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,183,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,184,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,185,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,186,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,187,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,189,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,190,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(132,191,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,193,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,197,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,201,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,202,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(150,203,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(152,203,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(153,203,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,204,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,205,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,206,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,207,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,208,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(155,209,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(159,210,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(160,210,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(161,210,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(164,211,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(165,211,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(167,223,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(178,227,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(179,227,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(180,227,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(181,227,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(182,228,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(129,1,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(10,2,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(102,101,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,102,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,104,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(102,111,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,112,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,114,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(102,116,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,117,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,118,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(102,141,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,142,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,144,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(131,146,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(120,147,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,148,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,150,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(139,152,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,153,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,154,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(120,155,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,157,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,159,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(135,161,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,163,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,164,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(120,165,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,166,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,167,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(120,169,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,171,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,173,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(141,175,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,177,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,179,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(120,180,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,181,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,183,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(121,185,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,186,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,187,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,189,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(121,190,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,192,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,193,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,197,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(109,199,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,202,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,204,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,205,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,206,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,207,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,208,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(156,209,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(157,209,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(158,209,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(170,209,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(171,209,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(172,209,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(173,209,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(176,209,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(177,209,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(11,2,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,102,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,104,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,112,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,114,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,117,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,118,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,142,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,144,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,148,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,150,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(140,152,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,153,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,154,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,157,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,159,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(133,161,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,163,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,164,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,166,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,167,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,171,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,173,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,177,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,179,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,181,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,183,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(122,185,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,186,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,187,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,189,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(122,190,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,193,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(109,195,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,197,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,202,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,204,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,205,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,206,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,207,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,208,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(13,2,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(148,2,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(149,2,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(154,2,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(168,2,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(169,2,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,102,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,104,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,112,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,114,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,117,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,118,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,142,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,144,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,148,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,150,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,153,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,157,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,159,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(134,161,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,163,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,166,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,167,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,171,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,173,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,177,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,181,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,183,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,186,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(123,187,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(123,189,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,193,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,197,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,202,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,204,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,205,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,206,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,207,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,208,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,102,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,112,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,117,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,119,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,142,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,148,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,153,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(124,154,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,157,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(138,159,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,163,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,166,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(138,167,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,171,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(138,173,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,177,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,181,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,186,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(124,187,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(124,189,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(102,193,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(102,208,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(126,154,6);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(126,187,6);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(126,189,6);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(127,154,7);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(127,187,7);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(127,189,7);

-- DATA FOR TABLE languages

INSERT INTO languages(id,is_default,prefix,title)	VALUES(1,1,'ru','Русский');
INSERT INTO languages(id,is_default,prefix,title)	VALUES(2,0,'en','English');

-- DATA FOR TABLE object_types

INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(1,0,6,1,0,0,'Группа пользователей');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(2,0,7,0,1,0,'Пользователь');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(4,0,0,0,0,0,'Раздел сайта');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(5,4,17,0,1,1,'Страницы');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(6,0,31,0,0,1,'Результаты поиска');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(10,0,13,0,0,0,'Меню сайта');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(11,4,28,0,0,0,'Обратная связь');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(12,4,34,0,1,1,'Лента статей');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(13,4,35,0,1,1,'Статья');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(14,4,37,0,1,1,'Категория каталога');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(15,4,38,0,1,1,'Элемент каталога');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(16,4,39,0,0,1,'Поиск по каталогу');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(17,4,41,0,1,1,'Категория галереи');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(18,4,42,0,1,1,'Элемент галереи');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(19,4,44,0,1,1,'Лента новостей');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(20,4,45,0,1,1,'Новость');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(21,4,24,0,0,1,'Карта_сайта');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(25,4,47,0,0,1,'Страница регистрации');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(26,4,48,0,1,1,'Акции');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(28,4,50,0,0,1,'Профиль пользователя');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(29,4,51,0,1,1,'Товар');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(30,4,52,0,1,1,'Категория товара');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(31,4,54,0,0,1,'Страница заказа');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(32,NULL,NULL,0,1,1,'Способ доставки');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(34,NULL,55,0,0,1,'Заказ');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(35,34,NULL,0,1,1,'Заказ инфо');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(36,NULL,NULL,0,1,1,'Города');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(54,NULL,NULL,0,1,1,'Справочничек');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(55,NULL,NULL,0,1,1,'Способы оплаты');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(56,NULL,28,0,1,1,'Обратная связь');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(57,NULL,56,0,1,1,'Отделы');

-- DATA FOR TABLE objects

INSERT INTO objects(id,id_type,is_locked,title)	VALUES(1,1,1,'Посетители');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(2,1,1,'Зарегестрированные пользователи');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(3,1,1,'Служба поддержки');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(4,1,1,'Администраторы сайта');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(5,2,1,'Витя');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(6,2,0,'Владелец сайта');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(1000,10,0,'Главное меню');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10000,5,0,'не Главная');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10001,6,0,'Результаты поиска');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10004,11,0,'Контакты');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10013,14,0,'Конфеты');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10014,14,0,'Печеньки');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10015,16,0,'Найдено в каталоге');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10016,10,0,'каталог');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10017,17,0,'Фотоотчеты');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10018,17,0,'Какая-то выставка 2008-2009');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10019,18,0,'выставка 1');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10020,18,0,'выставка 2');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10021,18,0,'выставка 3');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10022,14,0,'Каталог');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10024,2,0,'Новый');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10025,2,0,'admin');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10026,21,0,'Карта_сайта');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10027,5,0,'Новая страница');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10028,5,0,'Новая страница');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10029,1,0,'Третьи лица');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10030,2,0,'Новый');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10031,19,0,'Новая страница');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10032,19,0,'Новая страница');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10033,19,0,'Новости');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10034,5,0,'Демо');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10035,2,0,'kifirch');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10036,20,0,'Нововость1');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10037,20,0,'Новость2');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10038,20,0,'Новость3');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10041,25,0,'Регистрация');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10042,2,0,'Еще один');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10043,26,0,'Суперакция');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10044,2,0,'Новый');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10045,2,0,'Новый');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10046,2,0,'Вася');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10047,2,0,'Алексей');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10048,2,0,'qwe3');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10049,28,0,'Профиль');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10050,2,0,'qweqwewewwww');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10054,30,0,'Каталог');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10055,29,0,'Монитор');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10056,29,0,'Крем для рук “HandCramUltra”');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10057,29,0,'Гнямба');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10058,31,0,'Ваша корзина');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10061,32,0,'Забрать самостоятельно:0');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10062,32,0,'Доставка курьером:500');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10064,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10065,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10066,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10067,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10068,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10069,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10070,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10071,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10072,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10073,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10074,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10075,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10076,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10077,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10078,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10079,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10080,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10081,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10082,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10083,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10084,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10085,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10086,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10087,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10088,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10089,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10090,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10091,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10092,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10093,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10094,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10095,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10096,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10097,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10098,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10099,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10100,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10101,15,0,'Новый товар');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10102,36,0,'Радонеж!');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10103,36,0,'Суздаль');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10104,36,0,'Кижи');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10105,36,0,'Белгород');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10106,19,0,'Новостная лента');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10107,54,0,'чясамчс');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10108,54,0,'ывапывапывапы23к');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10109,54,0,'ывапапиваивап');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10110,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10111,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10112,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10113,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10114,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10115,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10116,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10117,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10118,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10119,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10120,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10121,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10122,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10123,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10124,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10125,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10126,29,0,'Гнямбочка');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10127,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10128,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10129,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10130,2,0,'Дима');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10131,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10132,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10133,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10134,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10135,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10136,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10137,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10138,2,0,'Марат Игоревич');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10140,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10141,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10142,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10143,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10144,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10145,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10146,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10147,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10148,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10149,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10150,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10151,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10152,32,0,'Доставка Почтой России:300');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10153,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10154,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10155,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10156,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10157,32,0,'Передать в метро:50');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10158,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10159,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10160,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10161,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10162,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10163,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10164,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10165,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10166,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10167,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10168,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10169,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10170,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10171,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10172,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10173,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10174,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10175,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10176,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10177,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10178,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10179,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10180,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10181,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10182,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10183,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10184,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10185,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10186,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10187,29,0,'Диван - трансформер');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10188,29,0,'Нечто');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10189,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10190,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10191,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10192,34,1,'Заказ №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10193,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10194,35,1,'Информация о заказе №');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10195,36,0,'гшз0гшз0-');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10196,5,0,'Bulletin');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10197,5,0,'Test');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10198,30,0,'Категория');

-- DATA FOR TABLE permissions_elements

INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(1,35,'edit',0);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(1,35,'view',0);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(2,34,'view',0);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(2,35,'edit',1);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(2,35,'view',1);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(3,34,'view',1);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(3,35,'',1);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(4,2,'edit',0);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(4,2,'view',0);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(4,16,'edit',0);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(4,16,'view',0);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(4,34,'view',1);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(4,35,'',1);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)	VALUES(10029,35,'view',1);

-- DATA FOR TABLE permissions_modules

INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,1,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,2,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,3,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,7,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,13,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,17,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,24,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,26,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,28,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,31,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,34,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,35,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,37,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,38,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,39,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,41,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,42,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,44,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,45,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,46,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,47,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,48,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,50,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,51,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,52,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,54,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,54,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,56,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(2,55,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,1,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,3,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,4,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,5,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,6,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,7,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,8,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,9,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,10,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,11,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,12,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,13,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,14,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,15,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,16,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,17,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,24,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,25,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,26,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,27,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,28,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,29,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,30,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,31,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,32,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,33,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,34,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,35,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,36,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,37,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,38,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,39,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,40,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,41,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,42,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,43,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,44,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,45,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,46,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,47,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,47,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,48,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,48,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,49,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,50,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,50,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,51,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,51,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,52,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,52,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,53,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,53,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,53,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,54,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,54,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,55,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,56,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,56,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,56,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,3,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,4,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,5,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,6,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,6,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,7,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,7,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,8,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,9,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,9,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,10,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,10,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,11,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,11,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,12,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,13,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,14,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,15,'edit',0);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,15,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,16,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,17,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,25,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,27,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,28,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,29,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,29,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,30,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,30,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,32,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,32,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,33,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,34,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,35,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,36,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,37,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,38,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,40,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,41,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,42,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,43,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,44,'edit',0);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,44,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,45,'edit',0);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,45,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,46,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,47,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,47,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,50,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,50,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,54,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,54,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,56,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,56,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(10029,3,'',0);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(10029,16,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(10029,43,'',0);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(10029,44,'edit',0);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(10029,44,'view',0);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(10029,45,'edit',0);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(10029,45,'view',0);

-- DATA FOR TABLE registry

INSERT INTO registry(var,val)	VALUES('articles_items_count','s:0:"";');
INSERT INTO registry(var,val)	VALUES('artic_active','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('artic_title','s:0:"";');
INSERT INTO registry(var,val)	VALUES('buy_without_reg','s:1:"1";');
INSERT INTO registry(var,val)	VALUES('catalog_big_size','s:4:"1024";');
INSERT INTO registry(var,val)	VALUES('catalog_items_count','s:0:"";');
INSERT INTO registry(var,val)	VALUES('catalog_kategory_size','s:2:"80";');
INSERT INTO registry(var,val)	VALUES('catalog_medium_size','s:3:"400";');
INSERT INTO registry(var,val)	VALUES('catalog_small_size','s:3:"170";');
INSERT INTO registry(var,val)	VALUES('gallery_big_size','s:4:"1024";');
INSERT INTO registry(var,val)	VALUES('gallery_items_count','s:0:"";');
INSERT INTO registry(var,val)	VALUES('gallery_kategory_size','s:2:"80";');
INSERT INTO registry(var,val)	VALUES('gallery_medium_size','s:3:"400";');
INSERT INTO registry(var,val)	VALUES('gallery_small_size','s:3:"170";');
INSERT INTO registry(var,val)	VALUES('gallery_square_big','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('gallery_square_kategory','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('gallery_square_medium','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('gallery_square_small','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('modules_order','a:7:{i:0;s:5:"admin";i:1;s:4:"data";i:2;s:4:"menu";i:3;s:4:"news";i:4;s:9:"templates";i:5;s:5:"users";i:6;s:5:"trash";}');
INSERT INTO registry(var,val)	VALUES('news_items_count','s:0:"";');
INSERT INTO registry(var,val)	VALUES('offers_big_size','s:0:"";');
INSERT INTO registry(var,val)	VALUES('offers_items_count','s:0:"";');
INSERT INTO registry(var,val)	VALUES('offers_medium_size','s:0:"";');
INSERT INTO registry(var,val)	VALUES('offers_small_size','s:0:"";');
INSERT INTO registry(var,val)	VALUES('offers_square_big','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('offers_square_medium','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('offers_square_small','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('parse_content','s:1:"1";');
INSERT INTO registry(var,val)	VALUES('robots_text','s:10:"aqsxasxc 
";');
INSERT INTO registry(var,val)	VALUES('search_active','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('site_description','s:0:"";');
INSERT INTO registry(var,val)	VALUES('site_keywords','s:10:"слово";');
INSERT INTO registry(var,val)	VALUES('site_name','s:0:"";');
INSERT INTO registry(var,val)	VALUES('square_big_active','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('square_kategory_active','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('square_medium_active','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('square_small_active','s:1:"0";');
INSERT INTO registry(var,val)	VALUES('users_active_mode','s:1:"1";');
INSERT INTO registry(var,val)	VALUES('use_urlnames','s:1:"1";');

-- DATA FOR TABLE shop_order_info

INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(1,6,10090,40);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(2,7,10093,40);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(3,8,10095,40);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(4,9,10097,40);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(5,10,10099,40);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(6,10,10100,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(7,11,10111,40);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(8,12,10113,40);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(9,13,10115,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(10,13,10116,42);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(11,13,10117,40);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(12,14,10119,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(13,15,10121,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(14,15,10122,42);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(15,15,10123,40);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(16,16,10125,40);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(17,17,10128,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(18,17,10129,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(19,18,10132,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(20,18,10133,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(21,19,10136,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(22,19,10137,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(23,20,10141,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(24,21,10143,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(25,21,10144,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(26,22,10146,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(27,23,10148,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(28,23,10149,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(29,24,10151,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(30,25,10154,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(31,26,10156,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(32,27,10159,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(33,28,10161,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(34,29,10163,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(35,30,10165,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(36,31,10167,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(37,32,10173,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(38,33,10175,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(39,34,10177,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(40,34,10178,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(41,35,10180,41);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(42,42,10190,46);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(43,42,10191,47);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(44,43,10193,47);
INSERT INTO shop_order_info(id,id_order,id_obj,id_element)	VALUES(45,43,10194,41);

-- DATA FOR TABLE shop_orders

INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(1,10079,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(2,10081,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(3,10083,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(4,10085,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(5,10087,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(6,10089,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(7,10092,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(8,10094,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(9,10096,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(10,10098,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(11,10110,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(12,10112,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(13,10114,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(14,10118,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(15,10120,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(16,10124,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(17,10127,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(18,10131,20);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(19,10135,20);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(20,10140,0);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(21,10142,21);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(22,10145,0);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(23,10147,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(24,10150,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(25,10153,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(26,10155,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(27,10158,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(28,10160,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(29,10162,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(30,10164,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(31,10166,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(32,10172,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(33,10174,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(34,10176,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(35,10179,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(36,10181,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(37,10182,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(38,10183,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(39,10184,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(40,10185,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(41,10186,7);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(42,10189,20);
INSERT INTO shop_orders(id,id_obj,id_user)	VALUES(43,10192,0);

-- DATA FOR TABLE templates

INSERT INTO templates(id,id_lang,is_default,filename,title)	VALUES(1,1,0,'default','Базовый Шаблон');
INSERT INTO templates(id,id_lang,is_default,filename,title)	VALUES(2,1,1,'template','Основной Шаблон');
INSERT INTO templates(id,id_lang,is_default,filename,title)	VALUES(3,1,0,1296479985,'Шаблон 31.01.11');

-- DATA FOR TABLE users

INSERT INTO users(id,name,id_object,id_usergroup,is_active,password)	VALUES(7,'master',5,3,1,'6442f810d42825ec2de9bfade765147d');
INSERT INTO users(id,name,id_object,id_usergroup,is_active,password)	VALUES(9,'admin',10025,3,1,'14714456e5d6446b6317cc063f061cef');
INSERT INTO users(id,name,id_object,id_usergroup,is_active,password)	VALUES(12,'kifirch',10035,10029,1,'9aec14c0642972bb19c4adbce2b01a2e');
INSERT INTO users(id,name,id_object,id_usergroup,is_active,password)	VALUES(13,'васьвась',10042,3,1,'cb7e0c4b949c2b120b0a048ab55b7282');
INSERT INTO users(id,name,id_object,id_usergroup,is_active,password)	VALUES(19,'qwe',10048,2,1,'f8382c54b2af7578bd84a11a8141c648');
INSERT INTO users(id,name,id_object,id_usergroup,is_active,password)	VALUES(20,'all4dk',10130,2,1,'d8c44d6a700b9e26065c8b3a7dfd8d83');
INSERT INTO users(id,name,id_object,id_usergroup,is_active,password)	VALUES(21,'Qwer',10138,2,1,'d8c44d6a700b9e26065c8b3a7dfd8d83');

-- DATA FOR TABLE views

INSERT INTO views(id,title,filename,id_etype)	VALUES(1,'Содержимое страницы','view',17);
INSERT INTO views(id,title,filename,id_etype)	VALUES(2,'Лента статей','category',34);
INSERT INTO views(id,title,filename,id_etype)	VALUES(3,'Статья','item',35);
INSERT INTO views(id,title,filename,id_etype)	VALUES(4,'Категория каталога','category',37);
INSERT INTO views(id,title,filename,id_etype)	VALUES(5,'Элемент каталога','item',38);
INSERT INTO views(id,title,filename,id_etype)	VALUES(6,'Категория галереи (lightbox)','lightbox',41);
INSERT INTO views(id,title,filename,id_etype)	VALUES(7,'Категория галереи (galleria)','galleria',41);

-- ALTER TABLE blocks


-- ALTER TABLE content

ALTER TABLE content ADD CONSTRAINT `fk_content_fields` FOREIGN KEY (`id_field`) REFERENCES `fields` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_content_objects` FOREIGN KEY (`id_obj`) REFERENCES `objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_rel_element` FOREIGN KEY (`val_rel_elem`) REFERENCES `elements` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
ADD CONSTRAINT `fk_rel_object` FOREIGN KEY (`val_rel_obj`) REFERENCES `objects` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- ALTER TABLE element_types


-- ALTER TABLE elements


-- ALTER TABLE field_groups


-- ALTER TABLE field_types


-- ALTER TABLE fields


-- ALTER TABLE fields_controller


-- ALTER TABLE languages


-- ALTER TABLE object_types


-- ALTER TABLE objects


-- ALTER TABLE permissions_elements


-- ALTER TABLE permissions_modules


-- ALTER TABLE registry


-- ALTER TABLE shop_order_info


-- ALTER TABLE shop_orders


-- ALTER TABLE templates


-- ALTER TABLE users


-- ALTER TABLE views


set foreign_key_checks = 1;

