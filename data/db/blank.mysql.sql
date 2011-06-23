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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  KEY `fk_rel_element` (`val_rel_elem`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- TABLE element_types


DROP TABLE IF EXISTS `element_types`;

CREATE TABLE `element_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module` varchar(45) NOT NULL,
  `controller` varchar(45) NOT NULL,
  `action` varchar(45) NOT NULL DEFAULT 'view',
  `title` varchar(255) DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`module`,`controller`),
  KEY `is_public` (`is_public`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

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
  KEY `fk_element_menu` (`id_menu`)) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

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
  KEY `fk_field_groups_object_types` (`id_obj_type`)) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8;

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
  KEY `fk_fields_field_types` (`id_type`)) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8;

-- TABLE fields_controller


DROP TABLE IF EXISTS `fields_controller`;

CREATE TABLE `fields_controller` (
  `id_field` int(10) unsigned NOT NULL,
  `id_group` int(10) unsigned NOT NULL,
  `ord` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_group`,`id_field`),
  KEY `fk_fields_controller_fields` (`id_field`),
  KEY `fk_filelds_controller_field_groups` (`id_group`),
  KEY `ord` (`ord`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

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
  KEY `fk_object_type_parent` (`id_parent`)) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

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
  KEY `is_locked` (`is_locked`)) ENGINE=InnoDB AUTO_INCREMENT=10013 DEFAULT CHARSET=utf8;

-- TABLE permissions_elements


DROP TABLE IF EXISTS `permissions_elements`;

CREATE TABLE `permissions_elements` (
  `id_owner` int(10) unsigned NOT NULL,
  `id_element` int(10) unsigned NOT NULL,
  `mode` varchar(45) NOT NULL,
  `allow` int(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_owner`,`id_element`,`mode`),
  KEY `fk_permissions_elements_elements` (`id_element`),
  KEY `fk_permissions_elements_usergroup` (`id_owner`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- TABLE permissions_modules


DROP TABLE IF EXISTS `permissions_modules`;

CREATE TABLE `permissions_modules` (
  `id_owner` int(10) unsigned NOT NULL,
  `id_etype` int(10) unsigned NOT NULL,
  `mode` varchar(45) NOT NULL DEFAULT '',
  `allow` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_owner`,`id_etype`,`mode`),
  KEY `fk_permissions_modules_element_types` (`id_etype`),
  KEY `fk_permissions_modules_usergroup` (`id_owner`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- TABLE registry


DROP TABLE IF EXISTS `registry`;

CREATE TABLE `registry` (
  `var` varchar(48) NOT NULL,
  `val` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`var`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  KEY `fk_templates_languages` (`id_lang`)) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

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
  KEY `fk_users_usergroup` (`id_usergroup`)) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `views`;

CREATE TABLE `views` (
 `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
 `title` varchar(100) COLLATE utf8_bin DEFAULT NULL,
 `filename` varchar(255) COLLATE utf8_bin DEFAULT NULL,
 `id_etype` int(10) unsigned DEFAULT NULL,
 PRIMARY KEY (`id`),
 KEY `fk_views_1` (`id_etype`)) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;


-- DATA FOR TABLE blocks


-- DATA FOR TABLE content
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10204, 187, NULL, NULL, 'all', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10206, 187, NULL, NULL, 'test@test.ru', NULL, NULL, NULL);

-- DATA FOR TABLE element_types

INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(1,'admin','','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(2,'admin','auth','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(3,'admin','module','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(4,'admin','config','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(5,'users','back','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(6,'users','group','Группы пользователей',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(7,'users','user','Пользователи',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(8,'data','back','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(9,'data','otype','Типы данных',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(10,'data','group','Группы полей',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(11,'data','field','Поля',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(12,'menu','back','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(13,'menu','','Меню сайта',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(14,'templates','back','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(15,'templates','','Шаблоны',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(16,'content','back','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(17,'content','','Контент',1);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(24,'content','sitemap','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(25,'trash','back','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(26,'content','artic','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(27,'feedback','back','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(28,'feedback','','Обратная связь',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(29,'system','back','Система',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(30,'blocks','back','Блоки',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(31,'search','','',0);
INSERT INTO element_types(id,module,controller,title,is_public)	VALUES(32,'search','back','Поиск',0);

-- DATA FOR TABLE elements

INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(1,'0',17,10000,1,'0',1000,1,'0',1,'Главная','2010-03-19 00:00:00',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(2,'0',31,10001,1,'0',NULL,1,'0',0,'Поиск','2010-03-19 00:00:00',1);
INSERT INTO elements(id,id_parent,id_type,id_obj,id_lang,id_tpl,id_menu,is_active,is_deleted,is_default,urlname,updatetime,ord)	VALUES(5,'0',28,10004,1,'0',1000,1,'0','0','Контакты','2010-03-19 00:00:00',5);

-- DATA FOR TABLE field_groups

INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(1,'usersgroup',1,1,'0',1,'Группа пользователей',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(2,'user',2,1,'0',1,'Пользователь',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(3,'menuset',10,1,'0',1,'Меню',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(101,'common',4,1,'0',1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(102,'seo',4,1,'0','0','Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(103,'menu',4,1,'0','0','Настройки меню',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(104,'page',4,1,'0','0','Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(105,'permissions',4,1,1,'0','Права доступа',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(111,'common',5,1,'0',1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(112,'seo',5,1,'0','0','Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(113,'menu',5,1,'0','0','Настройки меню',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(114,'page',5,1,'0','0','Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(115,'permissions',5,1,'0','0','Права доступа',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(116,'common',6,1,'0',1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(117,'seo',6,1,'0','0','Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(118,'page',6,1,'0','0','Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(119,'permissions',6,1,1,'0','Права доступа',5);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(141,'common',11,1,'0',1,'Редактирование содержимого страницы',1);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(142,'seo',11,1,'0','0','Настройки для поисковых систем',2);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(143,'menu',11,1,'0','0','Настройки меню',3);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(144,'page',11,1,1,'0','Настройки страницы',4);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(145,'permissions',11,1,1,'0','Права доступа',6);
INSERT INTO field_groups(id,name,id_obj_type,is_active,is_locked,is_visible,title,ord)	VALUES(146,'feedback',11,1,'0','0','Настройки формы обратной связи',5);

-- DATA FOR TABLE field_types

INSERT INTO field_types(id,name,is_virtual,title)	VALUES(1,'Boolean','0','Флаг');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(2,'Integer','0','Целое');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(3,'Float','0','Число с точкой');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(4,'String','0','Строка');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(5,'Text','0','Текст');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(6,'Select','0','Список');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(7,'MultiSelect','0','Список с множественным выбором');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(8,'MultiCheckbox','0','Группа флагов');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(9,'Radio','0','Переключатель');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(10,'File','0','Файл');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(11,'Date','0','Дата');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(12,'HtmlText','0','Текстовое поле с визуальным редактором');
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(13,'Email','0','Адрес электронной почты');
INSERT INTO field_types(id,name,is_virtual,title)   VALUES(14, 'Photo', '0', 'Фотография');
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
INSERT INTO field_types(id,name,is_virtual,title)	VALUES(112,'TemplateView',1,'Шаблон вида');

-- DATA FOR TABLE fields

INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(1,'name',100,'0',1,'0',1,1,'Название страницы','Короткое название страницы. Отображается в меню и в заголовке содержимого страницы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(9,'user_groupname',100,'0',1,'0',1,1,'Название','Короткое название группы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(10,'user_name',100,'0',1,'0',1,1,'Имя','Короткое название пользователя');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(11,'login',109,'0',1,'0',1,1,'Логин','Логин пользователя');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(12,'user_group',110,1,1,'0',1,1,'Группа','Группа пользователей, к которой принадлежит пользователь');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(13,'user_password',111,'0',1,'0',1,1,'Пароль','Здесь можно сменить пароль пользователя');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(14,'user_active',105,'0',1,'0',1,'0','Активирован','Активировать или блокировать пользователя');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(20,'menu_name',100,'0',1,'0',1,1,'Название блока меню','Короткое название меню');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(21,'menu_rooturl',4,'0',1,'0',1,'0','Ссылка','URL корневого элемента для навигации');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(22,'menu_class',4,'0',1,'0',1,'0','Название класса CSS','Класс CSS для стилизации вывода меню');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(102,'text',12,'0',1,'0',1,'0','Редактирование содержимого страницы','Используется для редактирования содержимого страницы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(103,'urlname',101,'0',1,'0',1,1,'Адрес страницы','Адрес страницы отображаемый в браузерной строке');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(104,'title',4,'0',1,'0',1,'0','Заголовок (Title)','Текст отображаемый в Мета-тегах TITLE страницы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(105,'title_text',4,'0',1,'0',1,'0','Заголовок страницы','Текст отображаемый в тегах заголовка (H1-H6)');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(106,'meta_keywords',4,'0',1,'0',1,'0','Ключевые слова (Keywords)','Текст отображаемый в Мета-тегах KEYWORDS страницы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(107,'meta_description',4,'0',1,'0',1,'0','Описание (Description)','Текст отображаемый в Мета-тегах DESCRIPTION страницы ');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(108,'no_index',1,'0',1,'0','0','0','Индексация поисковиками','Запретить индексацию поисковиками');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(109,'menu_sel',104,10,1,1,1,'0','Выбрать меню','Выбирите в каком меню должна отображаться эта страница');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(110,'menu_showsub',1,'0',1,'0',1,'0','Показывать подменю','Управление отображением подменю');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(111,'menu_collapsed',1,'0',1,'0',1,'0','Свернуть подменю','Управление отображением подменю');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(112,'menu_img_title',10,'0',1,'0',1,'0','Изображение заголовка','Изображение для заголовка');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(113,'menu_img_unactive',10,'0',1,'0',1,'0','Изображение неактивного элемента','Изображение для неактивного элемента меню');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(114,'menu_img_active',10,'0',1,'0',1,'0','Изображение активного элемента','Изображение для активного элемента меню');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(115,'datatype',102,'0',1,'0',1,1,'Тип данных','Используемый тип данных');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(116,'template',103,'0',1,'0',1,1,'Шаблон','Используемый шаблон страницы');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(117,'publish',105,'0',1,'0',1,'0','Опубликовать/скрыть','Для того чтобы скрыть страницу на сайте уберите отметку');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(118,'publish_date_to',11,'0',1,'0',1,'0','До','Дата снятия с публикации');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(119,'default',106,'0',1,'0',1,'0','Главная','Для того чтобы сделать эту страницу главной поставьте отметку');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(120,'description',12,'0',1,'0',1,'0','Описание','Текстовое описание');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(121,'news_preview',12,'0',1,'0',1,'0','Анонс','Анонс новости');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(122,'news_maintext',12,'0',1,'0',1,'0','Текст','Основной текст новости');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(123,'publish_arch',1,'0',1,'0',1,'0','Архив','Перевести в архив');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(124,'publish_date_from',11,'0',1,'0',1,'0','Дата публикации','Дата публикации');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(125,'publish_date_arch',11,'0',1,'0','0','0','В архив','Дата перевода в архив');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(126,'publish_src_text',4,'0',1,'0',1,'0','Источник','Текст ссылки на источник');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(127,'publish_src_link',4,'0',1,'0',1,'0','URL источника','URL ссылки на источник');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(128,'permissions_elements',107,1,1,'0','0','0','Привилегии','Установите права доступа на эту страницу');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(129,'permissions_modules',108,'0',1,'0','0','0','Права группы пользователей','Пользователи этой группы имеют нижеуказанные права');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(130,'feedback_subject',4,'0',1,'0',1,'0','Тема сообщения','Тема сообщения для отправляемых писем');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)	VALUES(131,'feedback_email',13,'0',1,'0',1,'0','E-mail','Адрес почтового ящика для получения отзывов');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(132,'element_photo',14,'0',1,'0',1,'0','Изображение','Основное изображение данного элемента');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(133,'catalog_item_preview',12,'0',1,'0',1,'0','Краткое описание', 'Краткое описание товара');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(134,'catalog_item_maintext',12,'0',1,'0',1,'0','Текст','Основной текст товара');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(135,'catalog_item_price',3,'0',1,'0',1,'0','Цена','Цена товара');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(138,'catalog_view',112,'0',1,'0',1,1,'Шаблон вида','Шаблон вида');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(139,'articles_preview',12,'0',1,'0',1,'0','Анонс','Анонс статьи');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(140,'articles_maintext',12,'0',1,'0',1,'0','Текст','Основной текст статьи');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(141,'gallery_item_preview',5,'0',1,'0',1,'0','Краткое описание','Краткое описание изображения');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(142,'bulletin_name',4,'0',1,'0',1,1,'Имя','Имя автора объявления');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(143,'bulletin_email',13,'0',1,'0',1,1,'E-mail','E-mail автора объявления');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(144,'bulletin_phone',4,'0',1,'0',1,'0','Телефон','Номер телефона автора объявления');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(145,'bulletin_maintext',12,'0',1,'0',1,1,'Объявление','Текст объявления');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(146,'faq_name',4,'0',1,'0',1,1,'Имя','Имя автора вопроса');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(147,'faq_email',13,'0',1,'0',1,1,'E-mail','E-mail автора вопроса');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(148,'faq_question',5,'0',1,'0',1,1,'Вопрос','Текст вопроса');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(149,'faq_answer',5,'0',1,'0',1,1,'Ответ','Текст ответа');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(150,'offers_src_text',4,'0',1,'0',1,'0','Ссылка на товар','Ссылка на существующую страницу с подробным описанием');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(151,'offers_item_prewiew',12,'0',1,'0',1,'0','Краткое описание','Краткое описание акции');
INSERT INTO fields(id,name,id_type,id_guide,is_locked,is_inheritable,is_public,is_required,title,tip)   VALUES(152,'offers_item_maintext',12,'0',1,'0',1,'0','Текст','Подробное описание акции');
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
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,141,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,142,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(109,143,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,144,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,145,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(130,146,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(129,1,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(10,2,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(102,101,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,102,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,104,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(102,111,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,112,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,114,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(102,141,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,142,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,144,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(131,146,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(11,2,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,102,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,104,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,112,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,114,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,142,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,144,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(13,2,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,102,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,104,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,112,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,114,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,142,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,144,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,102,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,112,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,142,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(1,116,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(102,116,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(103,117,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(104,117,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(105,117,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(106,117,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(107,117,5);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(115,118,1);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(116,118,2);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(117,118,3);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(119,118,4);
INSERT INTO fields_controller(id_field,id_group,ord)	VALUES(128,119,5);


-- DATA FOR TABLE languages

INSERT INTO languages(id,is_default,prefix,title)	VALUES(1,1,'ru','Русский');
INSERT INTO languages(id,is_default,prefix,title)	VALUES(2,'0','en','English');

-- DATA FOR TABLE object_types

INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(1,'0',6,1,'0','0','Группа пользователей');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(2,'0',7,'0','0','0','Пользователь');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(4,'0','0','0','0','0','Раздел сайта');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(5,4,17,'0',1,1,'Страницы');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(6,0,31,'0',0,1,'Результаты поиска');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(10,'0',13,'0','0','0','Меню сайта');
INSERT INTO object_types(id,id_parent,id_element_type,is_locked,is_guidable,is_public,title)	VALUES(58,NULL,NULL,'0','1','1','Список адресатов');

-- DATA FOR TABLE objects

INSERT INTO objects(id,id_type,is_locked,title)	VALUES(1,1,1,'Посетители');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(2,1,1,'Зарегистрированные пользователи');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(3,1,1,'Служба поддержки');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(4,1,1,'Администраторы сайта');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(5,2,1,'Специалист Фабрики сайтов');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(6,2,'0','Владелец сайта');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(1000,10,'0','Главное меню');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10000,5,'0','Главная');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10001,6,'0','Результаты поиска');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10004,11,'0','Контакты');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10204,58,'0','all');
INSERT INTO objects(id,id_type,is_locked,title)	VALUES(10206,58,'0','Основной');


-- DATA FOR TABLE permissions_elements

INSERT INTO permissions_elements(id_owner,id_element,mode,allow)    VALUES(4,2,'edit',0);
INSERT INTO permissions_elements(id_owner,id_element,mode,allow)    VALUES(4,2,'view',0);

-- DATA FOR TABLE permissions_modules

INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,2,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,7,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,17,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,24,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,26,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,28,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(1,31,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(2,2,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(2,7,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(2,17,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(2,24,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(2,26,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(2,28,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(2,31,'view',1);
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
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,13,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,13,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,14,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,15,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,15,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,16,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,17,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,17,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,24,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,25,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,26,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,27,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,28,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,28,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,29,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,30,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,31,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(3,32,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,1,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,3,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,4,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,5,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,7,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,12,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,13,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,13,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,14,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,15,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,15,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,16,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,17,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,17,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,25,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,27,'',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,28,'view',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,28,'edit',1);
INSERT INTO permissions_modules(id_owner,id_etype,mode,allow)	VALUES(4,30,'',1);

-- DATA FOR TABLE registry

INSERT INTO registry(var,val)	VALUES('modules_order','a:7:{i:0;s:5:"admin";i:1;s:4:"data";i:2;s:4:"menu";i:3;s:4:"news";i:4;s:9:"templates";i:5;s:5:"users";i:6;s:5:"trash";}');
INSERT INTO registry(var,val)	VALUES('site_description','s:0:"";');
INSERT INTO registry(var,val)	VALUES('site_keywords','s:0:"";');
INSERT INTO registry(var,val)	VALUES('site_name','s:0:"";');
INSERT INTO registry(var,val)	VALUES('use_urlnames','s:1:"1";');
INSERT INTO registry(var,val)   VALUES('catalog_big_size','s:4:"1024";');
INSERT INTO registry(var,val)   VALUES('catalog_medium_size','s:3:"400";');
INSERT INTO registry(var,val)   VALUES('catalog_small_size','s:3:"170";');
INSERT INTO registry(var,val)   VALUES('catalog_kategory_size','s:2:"80";');
INSERT INTO registry(var,val)   VALUES('search_active','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('square_big_active','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('square_medium_active','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('square_small_active','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('square_kategory_active','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('gallery_big_size','s:4:"1024";');
INSERT INTO registry(var,val)   VALUES('gallery_medium_size','s:3:"400";');
INSERT INTO registry(var,val)   VALUES('gallery_small_size','s:3:"170";');
INSERT INTO registry(var,val)   VALUES('gallery_kategory_size','s:2:"80";');
INSERT INTO registry(var,val)   VALUES('gallery_square_big','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('gallery_square_medium','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('gallery_square_small','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('gallery_square_kategory','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('offers_big_size','s:4:"1024";');
INSERT INTO registry(var,val)   VALUES('offers_medium_size','s:3:"400";');
INSERT INTO registry(var,val)   VALUES('offers_small_size','s:3:"170";');
INSERT INTO registry(var,val)   VALUES('offers_square_big','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('offers_square_medium','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('offers_square_small','s:1:"0";');
INSERT INTO registry(var,val)   VALUES('users_active_mode','s:1:"1";');
INSERT INTO registry(var,val)   VALUES('parse_content','s:1:"0";');


-- DATA FOR TABLE templates

INSERT INTO templates(id,id_lang,is_default,filename,title)	VALUES(1,1,'0','default','Базовый Шаблон');
INSERT INTO templates(id,id_lang,is_default,filename,title)	VALUES(2,1,1,'template','Основной Шаблон');

-- DATA FOR TABLE users

-- DATA FOR TABLE views

INSERT INTO views(id,title,filename,id_etype)	VALUES(1,'Содержимое страницы','view',17);

-- ALTER TABLE blocks


-- ALTER TABLE content

ALTER TABLE content ADD CONSTRAINT `fk_content_fields` FOREIGN KEY (`id_field`) REFERENCES `fields` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_content_objects` FOREIGN KEY (`id_obj`) REFERENCES `objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_rel_element` FOREIGN KEY (`val_rel_elem`) REFERENCES `elements` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
ADD CONSTRAINT `fk_rel_object` FOREIGN KEY (`val_rel_obj`) REFERENCES `objects` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- ALTER TABLE element_types


-- ALTER TABLE elements

ALTER TABLE elements ADD CONSTRAINT `fk_elements_languages` FOREIGN KEY (`id_lang`) REFERENCES `languages` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_elements_objects` FOREIGN KEY (`id_obj`) REFERENCES `objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_elements_templates` FOREIGN KEY (`id_tpl`) REFERENCES `templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_elements_types` FOREIGN KEY (`id_type`) REFERENCES `element_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_element_menu` FOREIGN KEY (`id_menu`) REFERENCES `objects` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
ADD CONSTRAINT `fk_element_parent` FOREIGN KEY (`id_parent`) REFERENCES `elements` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ALTER TABLE field_groups

ALTER TABLE field_groups ADD CONSTRAINT `fk_field_groups_object_types` FOREIGN KEY (`id_obj_type`) REFERENCES `object_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- ALTER TABLE field_types


-- ALTER TABLE fields

ALTER TABLE fields ADD CONSTRAINT `fk_fields_field_types` FOREIGN KEY (`id_type`) REFERENCES `field_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_fields_guide` FOREIGN KEY (`id_guide`) REFERENCES `object_types` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- ALTER TABLE fields_controller

ALTER TABLE fields_controller ADD CONSTRAINT `fk_fields_controller_fields` FOREIGN KEY (`id_field`) REFERENCES `fields` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_filelds_controller_field_groups` FOREIGN KEY (`id_group`) REFERENCES `field_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- ALTER TABLE languages


-- ALTER TABLE object_types

ALTER TABLE object_types ADD CONSTRAINT `fk_object_types_element_types` FOREIGN KEY (`id_element_type`) REFERENCES `element_types` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
ADD CONSTRAINT `fk_object_type_parent` FOREIGN KEY (`id_parent`) REFERENCES `object_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ALTER TABLE objects

ALTER TABLE objects ADD CONSTRAINT `fk_objects_object_types` FOREIGN KEY (`id_type`) REFERENCES `object_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ALTER TABLE permissions_elements

ALTER TABLE permissions_elements ADD CONSTRAINT `fk_permissions_elements_elements` FOREIGN KEY (`id_element`) REFERENCES `elements` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_permissions_elements_usergroup` FOREIGN KEY (`id_owner`) REFERENCES `objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- ALTER TABLE permissions_modules

ALTER TABLE permissions_modules ADD CONSTRAINT `fk_permissions_modules_element_types` FOREIGN KEY (`id_etype`) REFERENCES `element_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `fk_permissions_modules_usergroup` FOREIGN KEY (`id_owner`) REFERENCES `objects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- ALTER TABLE registry


-- ALTER TABLE templates

ALTER TABLE templates ADD CONSTRAINT `fk_templates_languages` FOREIGN KEY (`id_lang`) REFERENCES `languages` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- ALTER TABLE users

ALTER TABLE users ADD CONSTRAINT `fk_users_objects` FOREIGN KEY (`id_object`) REFERENCES `objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_users_usergroup` FOREIGN KEY (`id_usergroup`) REFERENCES `objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE views ADD CONSTRAINT `fk_views_1` FOREIGN KEY (`id_etype`) REFERENCES `element_types` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

set foreign_key_checks = 1;

