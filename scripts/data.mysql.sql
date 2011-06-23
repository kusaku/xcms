SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';


-- -----------------------------------------------------
-- Table `field_types`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `field_types` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(20) NULL DEFAULT NULL ,
  `is_virtual` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `title` VARCHAR(64) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name` (`name` ASC) ,
  INDEX `is_virtual` (`is_virtual` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `element_types`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `element_types` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `module` VARCHAR(45) NOT NULL ,
  `controller` VARCHAR(45) NOT NULL ,
  `title` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name` (`module` ASC, `controller` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `object_types`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `object_types` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `id_parent` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `id_element_type` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `is_locked` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `is_guidable` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `is_public` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 ,
  `title` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `is_public` (`is_public` ASC) ,
  INDEX `is_locked` (`is_locked` ASC) ,
  INDEX `is_guidable` (`is_guidable` ASC) ,
  INDEX `fk_object_types_element_types` (`id_element_type` ASC) ,
  INDEX `fk_object_type_parent` (`id_parent` ASC) ,
  CONSTRAINT `fk_object_types_element_types`
    FOREIGN KEY (`id_element_type` )
    REFERENCES `element_types` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_object_type_parent`
    FOREIGN KEY (`id_parent` )
    REFERENCES `object_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fields`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fields` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(64) NOT NULL ,
  `id_type` INT(10) UNSIGNED NOT NULL ,
  `id_guide` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `is_locked` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `is_inheritable` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `is_public` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 ,
  `is_required` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `title` VARCHAR(255) NULL DEFAULT NULL ,
  `tip` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name` (`name` ASC) ,
  INDEX `is_locked` (`is_locked` ASC) ,
  INDEX `is_inheritable` (`is_inheritable` ASC) ,
  INDEX `is_public` (`is_public` ASC) ,
  INDEX `is_required` (`is_required` ASC) ,
  INDEX `fk_fields_guide` (`id_guide` ASC) ,
  CONSTRAINT `fk_fields_field_types`
    FOREIGN KEY (`id_type` )
    REFERENCES `field_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fields_guide`
    FOREIGN KEY (`id_guide` )
    REFERENCES `object_types` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `field_groups`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `field_groups` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(64) NOT NULL ,
  `id_obj_type` INT(10) UNSIGNED NOT NULL ,
  `is_active` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 ,
  `is_locked` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `is_visible` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 ,
  `title` VARCHAR(255) NULL DEFAULT NULL ,
  `ord` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `ord` (`ord` ASC) ,
  INDEX `name` (`name` ASC) ,
  INDEX `is_active` (`is_active` ASC) ,
  INDEX `is_visible` (`is_visible` ASC) ,
  INDEX `is_locked` (`is_locked` ASC) ,
  INDEX `fk_field_groups_object_types` (`id_obj_type` ASC) ,
  CONSTRAINT `fk_field_groups_object_types`
    FOREIGN KEY (`id_obj_type` )
    REFERENCES `object_types` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `fields_controller`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `fields_controller` (
  `id_field` INT(10) UNSIGNED NOT NULL ,
  `id_group` INT(10) UNSIGNED NOT NULL ,
  `ord` INT(11) NULL DEFAULT NULL ,
  INDEX `fk_fields_controller_fields` (`id_field` ASC) ,
  INDEX `fk_filelds_controller_field_groups` (`id_group` ASC) ,
  INDEX `ord` (`ord` ASC) ,
  PRIMARY KEY (`id_group`, `id_field`) ,
  CONSTRAINT `fk_fields_controller_fields`
    FOREIGN KEY (`id_field` )
    REFERENCES `fields` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_filelds_controller_field_groups`
    FOREIGN KEY (`id_group` )
    REFERENCES `field_groups` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `languages`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `languages` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `is_default` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `prefix` VARCHAR(16) NOT NULL ,
  `title` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `prefix` (`prefix` ASC) ,
  INDEX `title` (`title` ASC) ,
  INDEX `is_default` (`is_default` ASC) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `templates`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `templates` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `id_lang` INT(10) UNSIGNED NOT NULL ,
  `is_default` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `filename` VARCHAR(64) NULL DEFAULT NULL ,
  `title` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `is_default` (`is_default` ASC) ,
  INDEX `filename` (`filename` ASC) ,
  INDEX `title` (`title` ASC) ,
  INDEX `fk_templates_languages` (`id_lang` ASC) ,
  CONSTRAINT `fk_templates_languages`
    FOREIGN KEY (`id_lang` )
    REFERENCES `languages` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `objects`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `objects` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `id_type` INT(10) UNSIGNED NOT NULL ,
  `is_locked` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `title` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_objects_object_types` (`id_type` ASC) ,
  INDEX `name` (`title` ASC) ,
  INDEX `is_locked` (`is_locked` ASC) ,
  CONSTRAINT `fk_objects_object_types`
    FOREIGN KEY (`id_type` )
    REFERENCES `object_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `elements`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `elements` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `id_parent` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `id_type` INT(10) UNSIGNED NOT NULL ,
  `id_obj` INT(10) UNSIGNED NOT NULL ,
  `id_lang` INT(10) UNSIGNED NOT NULL ,
  `id_tpl` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `id_menu` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `is_active` TINYINT(1) UNSIGNED NOT NULL DEFAULT 1 ,
  `is_deleted` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `is_default` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `urlname` VARCHAR(128) NULL DEFAULT NULL ,
  `updatetime` DATETIME NULL DEFAULT NULL ,
  `ord` INT(11) NULL DEFAULT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_elements_types` (`id_type` ASC) ,
  INDEX `fk_elements_languages` (`id_lang` ASC) ,
  INDEX `fk_elements_objects` (`id_obj` ASC) ,
  INDEX `fk_elements_templates` (`id_tpl` ASC) ,
  INDEX `is_default` (`is_default` ASC) ,
  UNIQUE INDEX `urlname` (`urlname` ASC) ,
  INDEX `is_deleted` (`is_deleted` ASC) ,
  INDEX `is_active` (`is_active` ASC) ,
  INDEX `ord` (`ord` ASC) ,
  INDEX `updatetime` (`updatetime` ASC) ,
  INDEX `fk_element_parent` (`id_parent` ASC) ,
  INDEX `fk_element_menu` (`id_menu` ASC) ,
  CONSTRAINT `fk_elements_templates`
    FOREIGN KEY (`id_tpl` )
    REFERENCES `templates` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_elements_objects`
    FOREIGN KEY (`id_obj` )
    REFERENCES `objects` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_elements_languages`
    FOREIGN KEY (`id_lang` )
    REFERENCES `languages` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_elements_types`
    FOREIGN KEY (`id_type` )
    REFERENCES `element_types` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_element_parent`
    FOREIGN KEY (`id_parent` )
    REFERENCES `elements` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_element_menu`
    FOREIGN KEY (`id_menu` )
    REFERENCES `objects` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `content`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `content` (
  `id_obj` INT(10) UNSIGNED NOT NULL ,
  `id_field` INT(10) UNSIGNED NOT NULL ,
  `val_int` BIGINT NULL DEFAULT NULL ,
  `val_float` FLOAT NULL DEFAULT NULL ,
  `val_varchar` VARCHAR(255) NULL DEFAULT NULL ,
  `val_text` MEDIUMTEXT NULL DEFAULT NULL ,
  `val_rel_obj` INT(10) UNSIGNED NULL DEFAULT NULL ,
  `val_rel_elem` INT(10) UNSIGNED NULL DEFAULT NULL ,
  INDEX `fk_content_objects` (`id_obj` ASC) ,
  INDEX `fk_content_fields` (`id_field` ASC) ,
  PRIMARY KEY (`id_obj`, `id_field`) ,
  INDEX `fk_rel_object` (`val_rel_obj` ASC) ,
  INDEX `fk_rel_element` (`val_rel_elem` ASC) ,
  CONSTRAINT `fk_content_objects`
    FOREIGN KEY (`id_obj` )
    REFERENCES `objects` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_content_fields`
    FOREIGN KEY (`id_field` )
    REFERENCES `fields` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rel_object`
    FOREIGN KEY (`val_rel_obj` )
    REFERENCES `objects` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rel_element`
    FOREIGN KEY (`val_rel_elem` )
    REFERENCES `elements` (`id` )
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `permissions_modules`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `permissions_modules` (
  `id_owner` INT(10) UNSIGNED NOT NULL ,
  `id_etype` INT(10) UNSIGNED NOT NULL ,
  `mode` VARCHAR(45) NOT NULL ,
  `allow` TINYINT(1) UNSIGNED NULL DEFAULT NULL ,
  PRIMARY KEY (`id_owner`, `id_etype`, `mode`) ,
  INDEX `fk_permissions_modules_element_types` (`id_etype` ASC) ,
  INDEX `fk_permissions_modules_usergroup` (`id_owner` ASC) ,
  CONSTRAINT `fk_permissions_modules_element_types`
    FOREIGN KEY (`id_etype` )
    REFERENCES `element_types` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_permissions_modules_usergroup`
    FOREIGN KEY (`id_owner` )
    REFERENCES `objects` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `registry`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `registry` (
  `var` VARCHAR(48) NOT NULL ,
  `val` VARCHAR(255) NULL DEFAULT NULL ,
  PRIMARY KEY (`var`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `permissions_elements`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `permissions_elements` (
  `id_owner` INT(10) UNSIGNED NOT NULL ,
  `id_element` INT(10) UNSIGNED NOT NULL ,
  `mode` VARCHAR(45) NOT NULL ,
  `allow` INT(1) UNSIGNED NULL DEFAULT NULL ,
  PRIMARY KEY (`id_owner`, `id_element`, `mode`) ,
  INDEX `fk_permissions_elements_elements` (`id_element` ASC) ,
  INDEX `fk_permissions_elements_usergroup` (`id_owner` ASC) ,
  CONSTRAINT `fk_permissions_elements_elements`
    FOREIGN KEY (`id_element` )
    REFERENCES `elements` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_permissions_elements_usergroup`
    FOREIGN KEY (`id_owner` )
    REFERENCES `objects` (`id` )
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `users` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(64) NOT NULL ,
  `id_object` INT(10) UNSIGNED NOT NULL ,
  `id_usergroup` INT(10) UNSIGNED NOT NULL ,
  `is_active` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 ,
  `password` VARCHAR(32) NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `name` (`name` ASC) ,
  INDEX `fk_users_objects` (`id_object` ASC) ,
  INDEX `fk_users_usergroup` (`id_usergroup` ASC) ,
  CONSTRAINT `fk_users_objects`
    FOREIGN KEY (`id_object` )
    REFERENCES `objects` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_usergroup`
    FOREIGN KEY (`id_usergroup` )
    REFERENCES `objects` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Data for table field_types
-- (id, name, is_virtual, title)
-- -----------------------------------------------------

INSERT INTO field_types VALUES (1, 'Boolean', 0, 'Флаг');
INSERT INTO field_types VALUES (2, 'Integer', 0, 'Целое');
INSERT INTO field_types VALUES (3, 'Float', 0, 'Число с точкой');
INSERT INTO field_types VALUES (4, 'String', 0, 'Строка');
INSERT INTO field_types VALUES (5, 'Text', 0, 'Текст');
INSERT INTO field_types VALUES (6, 'Select', 0, 'Список');
INSERT INTO field_types VALUES (7, 'MultiSelect', 0, 'Список с множественным выбором');
INSERT INTO field_types VALUES (8, 'MultiCheckbox', 0, 'Группа флагов');
INSERT INTO field_types VALUES (9, 'Radio', 0, 'Переключатель');
INSERT INTO field_types VALUES (10, 'File', 0, 'Файл');
INSERT INTO field_types VALUES (11, 'Date', 0, 'Дата');
INSERT INTO field_types VALUES (12, 'HtmlText', 0, 'Текстовое поле с визуальным редактором');
INSERT INTO field_types VALUES (13, 'Email', 0, 'Адрес электронной почты');
INSERT INTO field_types VALUES (100, 'Name', 1, 'Название');
INSERT INTO field_types VALUES (101, 'Urlname', 1, 'Псевдостатический адрес');
INSERT INTO field_types VALUES (102, 'ObjType', 1, 'Тип данных');
INSERT INTO field_types VALUES (103, 'Template', 1, 'Шаблон');
INSERT INTO field_types VALUES (104, 'Menu', 1, 'Меню');
INSERT INTO field_types VALUES (105, 'Active', 1, 'Активность');
INSERT INTO field_types VALUES (106, 'DefaultPage', 1, 'Страница по-умолчанию');
INSERT INTO field_types VALUES (107, 'ElementPermissions', 1, 'Права доступа на элемент');
INSERT INTO field_types VALUES (108, 'ModulePermissions', 1, 'Права доступа на модуль');
INSERT INTO field_types VALUES (109, 'UserLogin', 1, 'Логин пользователя');
INSERT INTO field_types VALUES (110, 'UserGroup', 1, 'Группа пользователей');
INSERT INTO field_types VALUES (111, 'UserPassword', 1, 'Пароль пользователя');


-- -----------------------------------------------------
-- Data for table element_types
-- (id, module, controller, title)
-- -----------------------------------------------------

INSERT INTO element_types VALUES (1, 'admin', '', NULL);
INSERT INTO element_types VALUES (2, 'admin', 'auth', NULL);
INSERT INTO element_types VALUES (3, 'admin', 'module', NULL);
INSERT INTO element_types VALUES (4, 'admin', 'config', NULL);
INSERT INTO element_types VALUES (5, 'users', 'back', NULL);
INSERT INTO element_types VALUES (6, 'users', 'group', 'Группы пользователей');
INSERT INTO element_types VALUES (7, 'users', 'user', 'Пользователи');
INSERT INTO element_types VALUES (8, 'data', 'back', NULL);
INSERT INTO element_types VALUES (9, 'data', 'otype', 'Типы данных' );
INSERT INTO element_types VALUES (10, 'data', 'group', 'Группы полей');
INSERT INTO element_types VALUES (11, 'data', 'field', 'Поля');
INSERT INTO element_types VALUES (12, 'menu', 'back', NULL);
INSERT INTO element_types VALUES (13, 'menu', '', 'Меню сайта');
INSERT INTO element_types VALUES (14, 'templates', 'back', NULL);
INSERT INTO element_types VALUES (15, 'templates', '', 'Шаблоны');
INSERT INTO element_types VALUES (16, 'content', 'back', NULL);
INSERT INTO element_types VALUES (17, 'content', '', 'Контент');
INSERT INTO element_types VALUES (18, 'news', 'back', NULL);
INSERT INTO element_types VALUES (19, 'news', 'category', 'Ленты новостей');
INSERT INTO element_types VALUES (20, 'news', 'item', 'Новости');
INSERT INTO element_types VALUES (24, 'content', 'sitemap', NULL);
INSERT INTO element_types VALUES (25, 'trash', 'back', NULL);
INSERT INTO element_types VALUES (26, 'content', 'artic', NULL);
INSERT INTO element_types VALUES (27, 'feedback', 'back', NULL);
INSERT INTO element_types VALUES (28, 'feedback', '', 'Обратая связь');



-- -----------------------------------------------------
-- Data for table object_types
-- (id, id_parent, id_element_type, is_locked, is_guidable, is_public, title)
-- -----------------------------------------------------

INSERT INTO object_types VALUES (1, NULL, 6, 1, 0, 0, 'Группа пользователей');
INSERT INTO object_types VALUES (2, NULL, 7, 0, 0, 0, 'Пользователь');
-- INSERT INTO object_types VALUES (3, 0, NULL, 0, 0, 0, 'Справочник');
INSERT INTO object_types VALUES (4, NULL, NULL, 0, 0, 0, 'Раздел сайта');
INSERT INTO object_types VALUES (5, 4, 17, 0, 1, 1, 'Контент');
INSERT INTO object_types VALUES (6, 4, 19, 0, 1, 1, 'Лента новостей');
INSERT INTO object_types VALUES (7, 4, 20, 0, 1, 1, 'Новость');
-- INSERT INTO object_types VALUES (8, 4, 22, 0, 1, 1, 'Категория каталога');
-- INSERT INTO object_types VALUES (9, 4, 23, 0, 1, 1, 'Элемент каталога');
INSERT INTO object_types VALUES (10, NULL, 13, 0, 0, 0, 'Меню сайта');
INSERT INTO object_types VALUES (11, 4, 28, 0, 0, 0, 'Обратная связь');



-- -----------------------------------------------------
-- Data for table fields
-- (id, name, id_type, id_guide, is_locked, is_inheritable, is_public, is_required, title, tip)
-- -----------------------------------------------------

INSERT INTO fields VALUES (1, 'name', 100, NULL, 1, 0, 1, 1, 'Название страницы', 'Короткое название страницы. Отображается в меню и в заголовке содержимого страницы');
INSERT INTO fields VALUES (9, 'user_groupname', 100, NULL, 1, 0, 1, 1, 'Название', 'Короткое название группы');
INSERT INTO fields VALUES (10, 'user_name', 100, NULL, 1, 0, 1, 1, 'Имя', 'Короткое название пользователя');
INSERT INTO fields VALUES (11, 'login', 109, NULL, 1, 0, 1, 1, 'Логин', 'Логин пользователя');
INSERT INTO fields VALUES (12, 'user_group', 110, 1, 1, 0, 1, 1, 'Группа', 'Группа пользователей, к которой принадлежит пользователь');
INSERT INTO fields VALUES (13, 'user_password', 111, NULL, 1, 0, 1, 1, 'Пароль', 'Здесь можно сменить пароль пользователя');
INSERT INTO fields VALUES (14, 'user_active', 105, NULL, 1, 0, 1, 0, 'Активирован', 'Активировать или блокировать пользователя');
INSERT INTO fields VALUES (20, 'menu_name', 100, NULL, 1, 0, 1, 1, 'Название блока меню', 'Короткое название меню');
INSERT INTO fields VALUES (21, 'menu_rooturl', 4, NULL, 1, 0, 1, 0, 'Ссылка', 'URL корневого элемента для навигации');
INSERT INTO fields VALUES (102, 'text', 12, NULL, 1, 0, 1, 0, 'Редактирование содержимого страницы', 'Используется для редактирования содержимого страницы');
INSERT INTO fields VALUES (103, 'urlname', 101, NULL, 1, 0, 1, 1, 'Адрес страницы', 'Адрес страницы отображаемый в браузерной строке');
INSERT INTO fields VALUES (104, 'title', 4, NULL, 1, 0, 1, 0, 'Заголовок (Title)', 'Текст отображаемый в Мета-тегах TITLE страницы');
INSERT INTO fields VALUES (105, 'title_text', 4, NULL, 1, 0, 1, 0, 'Заголовок страницы', 'Текст отображаемый в тегах заголовка (H1-H6)');
INSERT INTO fields VALUES (106, 'meta_keywords', 4, NULL, 1, 0, 1, 0, 'Ключевые слова (Keywords)', 'Текст отображаемый в Мета-тегах KEYWORDS страницы');
INSERT INTO fields VALUES (107, 'meta_description', 4, NULL, 1, 0, 1, 0, 'Описание (Description)', 'Текст отображаемый в Мета-тегах DESCRIPTION страницы ');
INSERT INTO fields VALUES (108, 'no_index', 1, NULL, 1, 0, 0, 0, 'Индексация поисковиками', 'Запретить индексацию поисковиками');
INSERT INTO fields VALUES (109, 'menu_sel', 104, 10, 1, 0, 1, 0, 'Выбрать меню', 'Выбирите в каком меню должна отображаться эта страница');
INSERT INTO fields VALUES (110, 'menu_showsub', 1, NULL, 1, 0, 1, 0, 'Показывать подменю', 'Управление отображением подменю');
INSERT INTO fields VALUES (111, 'menu_collapsed', 1, NULL, 1, 0, 1, 0, 'Свернуть подменю', 'Управление отображением подменю');
INSERT INTO fields VALUES (112, 'menu_img_title', 10, NULL, 1, 0, 1, 0, 'Изображение заголовка', 'Изображение для заголовка');
INSERT INTO fields VALUES (113, 'menu_img_unactive', 10, NULL, 1, 0, 1, 0, 'Изображение неактивного элемента', 'Изображение для неактивного элемента меню');
INSERT INTO fields VALUES (114, 'menu_img_active', 10, NULL, 1, 0, 1, 0, 'Изображение активного элемента', 'Изображение для активного элемента меню');
INSERT INTO fields VALUES (115, 'datatype', 102, NULL, 1, 0, 1, 1, 'Тип данных', 'Используемый тип данных');
INSERT INTO fields VALUES (116, 'template', 103, NULL, 1, 0, 1, 1, 'Шаблон', 'Используемый шаблон страницы');
INSERT INTO fields VALUES (117, 'publish', 105, NULL, 1, 0, 1, 0, 'Опубликовать/скрыть', 'Для того чтобы скрыть страницу на сайте уберите отметку');
INSERT INTO fields VALUES (118, 'publish_date_to', 11, NULL, 1, 0, 1, 0, 'До', 'Дата снятия с публикации');
INSERT INTO fields VALUES (119, 'default', 106, NULL, 1, 0, 1, 0, 'Главная', 'Для того чтобы сделать эту страницу главной поставьте отметку');
INSERT INTO fields VALUES (120, 'description', 12, NULL, 1, 0, 1, 0, 'Описание', 'Текстовое описание');
INSERT INTO fields VALUES (121, 'news_preview', 12, NULL, 1, 0, 1, 0, 'Анонс', 'Анонс новости');
INSERT INTO fields VALUES (122, 'news_maintext', 12, NULL, 1, 0, 1, 0, 'Текст', 'Основной текст новости');
INSERT INTO fields VALUES (123, 'publish_arch', 1, NULL, 1, 0, 1, 0, 'Архив', 'Перевести в архив');
INSERT INTO fields VALUES (124, 'publish_date_from', 11, NULL, 1, 0, 1, 0, 'Дата публикации', 'Дата публикации');
INSERT INTO fields VALUES (125, 'publish_date_arch', 11, NULL, 1, 0, 0, 0, 'В архив', 'Дата перевода в архив');
INSERT INTO fields VALUES (126, 'publish_src_text', 4, NULL, 1, 0, 1, 0, 'Источник', 'Текст ссылки на источник');
INSERT INTO fields VALUES (127, 'publish_src_link', 4, NULL, 1, 0, 1, 0, 'URL источника', 'URL ссылки на источник');
INSERT INTO fields VALUES (128, 'permissions_elements', 107, 1, 1, 0, 0, 0, 'Привилегии', 'Установите права доступа на эту страницу');
INSERT INTO fields VALUES (129, 'permissions_modules', 108, NULL, 1, 0, 0, 0, 'Права группы пользователей', 'Пользователи этой группы имеют нижеуказанные права');
INSERT INTO fields VALUES (130, 'feedback_subject', 4, NULL, 1, 0, 1, 0, 'Тема сообщения', 'Тема сообщения для отправляемых писем');
INSERT INTO fields VALUES (131, 'feedback_email', 13, NULL, 1, 0, 1, 0, 'E-mail', 'Адрес почтового ящика для получения отзывов');


-- -----------------------------------------------------
-- Data for table field_groups
-- (id, name, id_obj_type, is_active, is_locked, is_visible, title, ord)
-- -----------------------------------------------------

INSERT INTO field_groups VALUES (1, 'usersgroup', 1, 1, 0, 1, 'Группа пользователей', 1);
INSERT INTO field_groups VALUES (2, 'user', 2, 1, 0, 1, 'Пользователь', 1);
INSERT INTO field_groups VALUES (3, 'menuset', 10, 1, 0, 1, 'Меню', 1);

INSERT INTO field_groups VALUES (101, 'common', 4, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO field_groups VALUES (102, 'seo', 4, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO field_groups VALUES (103, 'menu', 4, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO field_groups VALUES (104, 'page', 4, 1, 0, 0, 'Настройки страницы', 4);
INSERT INTO field_groups VALUES (105, 'permissions', 4, 1, 1, 0, 'Права доступа', 5);

INSERT INTO field_groups VALUES (111, 'common', 5, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO field_groups VALUES (112, 'seo', 5, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO field_groups VALUES (113, 'menu', 5, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO field_groups VALUES (114, 'page', 5, 1, 0, 0, 'Настройки страницы', 4);
INSERT INTO field_groups VALUES (115, 'permissions', 5, 1, 0, 0, 'Права доступа', 5);

INSERT INTO field_groups VALUES (121, 'common', 6, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO field_groups VALUES (122, 'seo', 6, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO field_groups VALUES (123, 'menu', 6, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO field_groups VALUES (124, 'page', 6, 1, 1, 0, 'Настройки страницы', 4);
INSERT INTO field_groups VALUES (125, 'permissions', 6, 1, 1, 0, 'Права доступа', 5);

INSERT INTO field_groups VALUES (131, 'common', 7, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO field_groups VALUES (132, 'seo', 7, 1, 1, 0, 'Настройки для поисковых систем', 2);
INSERT INTO field_groups VALUES (134, 'page', 7, 1, 1, 0, 'Настройки страницы', 4);

INSERT INTO field_groups VALUES (141, 'common', 11, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO field_groups VALUES (142, 'seo', 11, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO field_groups VALUES (143, 'menu', 11, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO field_groups VALUES (144, 'page', 11, 1, 1, 0, 'Настройки страницы', 4);
INSERT INTO field_groups VALUES (145, 'permissions', 11, 1, 1, 0, 'Права доступа', 6);
INSERT INTO field_groups VALUES (146, 'feedback', 11, 1, 0, 0, 'Настройки формы обратной связи', 5);



-- -----------------------------------------------------
-- Data for table fields_controller
-- -----------------------------------------------------

-- Группа пользователей
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (9, 1, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (129, 1, 2);
-- Пользователь
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (14, 2, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (10, 2, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (11, 2, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (13, 2, 4);
-- INSERT INTO fields_controller (id_field, id_group, ord) VALUES (12, 2, 5);
-- Меню
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (20, 3, 1);
-- Раздел сайта
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (1, 101, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (102, 101, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (104, 102, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (103, 102, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (106, 102, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (105, 102, 4);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (107, 102, 5);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (109, 103, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (115, 104, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (116, 104, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (117, 104, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (119, 104, 4);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (128, 105, 1);
-- Контент
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (1, 111, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (102, 111, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (104, 112, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (103, 112, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (106, 112, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (105, 112, 4);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (107, 112, 5);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (109, 113, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (115, 114, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (116, 114, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (117, 114, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (119, 114, 4);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (128, 115, 1);
-- Лента новостей
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (1, 121, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (120, 121, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (104, 122, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (103, 122, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (106, 122, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (105, 122, 4);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (107, 122, 5);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (109, 123, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (115, 124, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (116, 124, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (117, 124, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (119, 124, 4);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (128, 125, 1);
-- Новость
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (1, 131, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (121, 131, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (122, 131, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (104, 132, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (103, 132, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (106, 132, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (105, 132, 4);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (107, 132, 5);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (115, 134, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (116, 134, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (117, 134, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (123, 134, 4);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (124, 134, 5);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (126, 134, 6);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (127, 134, 7);
-- Обратная связь
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (1, 141, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (102, 141, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (104, 142, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (103, 142, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (106, 142, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (105, 142, 4);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (107, 142, 5);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (109, 143, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (115, 144, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (116, 144, 2);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (117, 144, 3);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (119, 144, 4);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (128, 145, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (130, 146, 1);
INSERT INTO fields_controller (id_field, id_group, ord) VALUES (131, 146, 2);


-- -----------------------------------------------------
-- Data for table languages
-- -----------------------------------------------------

INSERT INTO languages (id, is_default, prefix, title) VALUES (1, 1, 'ru', 'Русский');
INSERT INTO languages (id, is_default, prefix, title) VALUES (2, 0, 'en', 'English');



-- -----------------------------------------------------
-- Data for table templates
-- (id, id_lang, is_default, filename, title)
-- -----------------------------------------------------

INSERT INTO templates VALUES (1, 1, 0, 'default', 'Базовый Шаблон');
INSERT INTO templates VALUES (2, 1, 1, 'template', 'Основной Шаблон');


-- -----------------------------------------------------
-- Data for table objects
-- (id, id_type, is_locked, title)
-- -----------------------------------------------------

INSERT INTO objects VALUES (1,1,1,'Посетители');
INSERT INTO objects VALUES (2,1,1,'Зарегестрированные пользователи');
INSERT INTO objects VALUES (3,1,1,'Служба поддержки'); -- Administrator
INSERT INTO objects VALUES (4,1,1,'Администраторы сайта'); -- Limited
INSERT INTO objects VALUES (5,2,1,'Специалист Фабрики сайтов');
INSERT INTO objects VALUES (6,2,0,'Владелец сайта');
INSERT INTO objects VALUES (1000,10,0,'Главное меню');
INSERT INTO objects VALUES (1001,10,0,'Боковое меню');
INSERT INTO objects VALUES (10000,5,0,'Главная');
INSERT INTO objects VALUES (10001,5,0,'Наши услуги');
INSERT INTO objects VALUES (10002,5,0,'Вопросы и Ответы');
INSERT INTO objects VALUES (10003,5,0,'Почему Кипр?');
INSERT INTO objects VALUES (10004,11,0,'Контакты');
INSERT INTO objects VALUES (10005,5,0,'Статьи');
INSERT INTO objects VALUES (10006,5,0,'Кипр - родина Афродиты');
INSERT INTO objects VALUES (10007,5,0,'Весёлый день для всей семьи');
INSERT INTO objects VALUES (10008,5,0,'Аренда дома на Кипре');
INSERT INTO objects VALUES (10009,6,0,'Новости');
INSERT INTO objects VALUES (10010,7,0,'Новость 1');
INSERT INTO objects VALUES (10011,7,0,'Новость 2');

-- -----------------------------------------------------
-- Data for table users
-- (id, name, id_object, id_usergroup, is_active, password)
-- -----------------------------------------------------

INSERT INTO users VALUES (1, 'master', 5, 3, 1, '6442f810d42825ec2de9bfade765147d');
INSERT INTO users VALUES (2, 'fs', 6, 4, 1, '');


-- -----------------------------------------------------
-- Data for table elements
-- (id, id_parent, id_type, id_obj, id_lang, id_tpl, id_menu, is_active, is_deleted, is_default, urlname, updatetime, ord)
-- -----------------------------------------------------

INSERT INTO elements VALUES(1,NULL,17,10000,1,NULL,1000,1,0,1,'Главная','2010-03-19',1);
INSERT INTO elements VALUES(2,NULL,17,10001,1,NULL,1000,1,0,0,'Наши_услуги','2010-03-19',2);
INSERT INTO elements VALUES(3,NULL,17,10002,1,NULL,1000,1,0,0,'Вопросы_и_Ответы','2010-03-19',3);
INSERT INTO elements VALUES(4,NULL,17,10003,1,NULL,1000,1,0,0,'Почему_Кипр','2010-03-19',4);
INSERT INTO elements VALUES(5,NULL,28,10004,1,NULL,1000,1,0,0,'Контакты','2010-03-19',5);
INSERT INTO elements VALUES(6,NULL,17,10005,1,NULL,NULL,1,0,0,'Статьи','2010-03-19',6);
INSERT INTO elements VALUES(7,6,17,10006,1,NULL,1001,1,0,0,'Кипр_-_родина_Афродиты','2010-03-19',1);
INSERT INTO elements VALUES(8,6,17,10007,1,NULL,1001,1,0,0,'Весёлый_день_для_всей_семьи','2010-03-19',2);
INSERT INTO elements VALUES(9,6,17,10008,1,NULL,1001,1,0,0,'Аренда_дома_на_Кипре','2010-03-19',3);
INSERT INTO elements VALUES(10,NULL,19,10009,1,NULL,NULL,1,0,0,'Новости','2010-03-19',7);
INSERT INTO elements VALUES(11,10,20,10010,1,NULL,NULL,1,0,0,'Новость1','2010-03-19',1);
INSERT INTO elements VALUES(12,10,20,10011,1,NULL,NULL,1,0,0,'Новость2','2010-03-19',2);


-- -----------------------------------------------------
-- Data for table content
-- (id_obj, id_field, val_int, val_float, val_varchar, val_text, val_rel_obj, val_rel_elem)
-- -----------------------------------------------------

INSERT INTO content VALUES (10000,102,NULL,NULL,NULL,'<p style="padding-left: 20px;"><img style="float: right;" src="/upload/image/main1.jpg" alt="недвижимость на кипре" align="right" />&nbsp;&nbsp;&nbsp; Кипр - земля легенд и грез, красоты и  вдохновения. Роскошная средиземноморская природа и легкодоступное  географическое расположение призывают гостей острова сделать его своим вторым  домом. Всё собрано вместе в одном солнечном Кипре. Полное спокойствие и  городская суета всего в минуте друг от друга. А историческое богатство и  современные удобства соседствуют друг с другом. Простота жизненного стиля идет  рука об руку с современной инфраструктурой. А самое главное, остров известен во  всем мире своими гостеприимными и доброжелательными жителями, которые принимают  постоянно увеличивающееся количество эмигрантов в свою среду. На острове широко  распространены английский и русский языки, преступности почти нет, а уровень  жизни неизменно вызывает зависть. Здесь хочется остаться...</p>
<p>&nbsp;</p>
<p><span style="font-size: small;"><strong>Мы предлагаем:</strong></span></p>
<p>&nbsp;</p>
<ul style="list-style-type: disc; list-style-image: none; list-style-position: outside;">
<li>Все виды недвижимости, включая новостройки, вторичное жильё и коммерческую недвижимость <strong>на юго-восточном побережье Кипра, от Ларнаки до Айа-напы и Протараса</strong>, а также в Никоссии.<br /><br /></li>
<li>Широкий выбор  новых объектов по ценам застройщика от квартир-студий до эксклюзивных вилл. Все  новостройки с отделкой &laquo;под ключ&raquo;, включая межкомнатные двери, напольные  покрытия, встроенную кухню, плательные шкафы и сантехнику.<br /><br /></li>
<li>Организацию смотрового тура<br /><br /></li>
<li>Открытие счета в кипрском банке<br /><br /></li>
<li>Помощь в получении ипотечного кредита в банке Кипра- до  80% от стоимости недвижимости под низкие европейские ставки<br /><br /></li>
<li>Юридическое сопровождение на всех этапах сделки<br /><br /></li>
<li>Уход за недвижимостью и сдача ее в аренду на время вашего  отсутствия.<br /><br /></li>
<li>Помощь в приобретении обстановки для дома.  Гарантированные значительные скидки при покупке в магазинах Кипра мебели,  бытовой техники и электроники.<br /><br /></li>
<li>Помощь в получении вида на жительство<br /><br /></li>
<li>Регистрацию компаний на Кипре<br /><br /></li>
<li>Все виды страхования<br /><br /></li>
<li>Недвижимость в аренду - виллы и апартаменты на побережье - от недорогих квартир до вилл класса "люкс".<br /><br /></li>
</ul>
<p>&nbsp;</p>
<p><span style="font-size: small;"><strong>Мы  поможем вам найти дом вашей мечты или превосходный вариант для инвестиций в  недвижимость на Кипре</strong><strong>!</strong></span></p>
<p><span style="font-size: small;"><strong><br /></strong></span></p>
<p><img src="/upload/image/main2.jpg" alt="недвижимость на кипре и купить дом на кипре" width="580" height="370" /></p>
<h2 style="text-align: center; font-family: Comic Sans MS;"><span style="font-size: large;">Недвижимость на Кипре: это выгодно</span></h2>
<p style="padding-left: 25px;">Надо отметить, что рынок недвижимости на Кипре предлагает  широкий ассортимент как прекрасных вилл на побережье, так и комфортабельных  апартаментов, которые характеризуются широчайшей доступностью. Желающих купить дом на Кипре довольно много &ndash; и  среди местных жителей, и среди иностранных граждан. Да и немудрено. Ведь  покупка недвижимости на Кипре представляется очень выгодным мероприятием.</p>
<p style="padding-left: 50px;">Собственная недвижимость на Кипре &ndash; это полноценный  отдых в любое время года.</p>
<p style="padding-left: 50px;">Собственная недвижимость на Кипре &ndash; это доступность  чистого моря, солнца, фруктов и овощей практически круглый год.</p>
<p style="padding-left: 50px;">Собственная <a title="Недвижимость на Кипре может стать твоей реальностью!" href="../pages_22/index.html">недвижимость на Кипре</a> &ndash; это прекрасное вложение  средств.</p>
<p style="padding-left: 25px;">Уникальность Кипра  состоит в том, что, имея чистейшую экологию, он со всех сторон омывается Cредиземным морем и  характеризуется разнообразием как горных, так и равнинных пейзажей. Это одна  сторона &ndash; природная. Что касается социального фактора, надо отметить, что  правительство страны всячески поощряет приезд туристов и инвесторов и стойко  держит лидирующие позиции в сфере туризма и инвестиций.</p>
<p style="padding-left: 50px;">Приобретение недвижимости на Кипре в коммерческих  целях &ndash; тоже отличный шаг. Развитость кипрской инфраструктуры удивительна.  Высочайший уровень сервиса и нескончаемый поток туристов неизменно приводит к  мысли о собственном бизнесе в этих чудесных краях.   КупиДОМиЯ с радостью  поможет Вам разобраться в деталях покупки недвижимости  на Кипре (будь то квартира, вилла, отель, апартаменты, бунгало или дом на Кипре).</p>
<p style="padding-left: 25px;">Если Вас всё же не интересует  покупка недвижимости, Вы можете обратиться к нам для организации аренды дома на Кипре на любой  интересующий Вас период.</p>
<p style="padding-left: 50px;">Добро пожаловать на волшебный  остров голубой мечты! Добро пожаловать на Кипр!</p>
<p><a style="color: #ffffff; text-decoration: none;" onclick="document.getElementById(''podrobnee2'').style.display = document.getElementById(''podrobnee2'').style.display == ''none'' ? ''block'' : ''none'';" href="javascript:void(0)">...</a></p>
<div id="podrobnee2" style="display: block;">
<div style="text-align: center;">
<h1 style="font-family: Comic Sans MS;">В ЭТОМ ДОМЕ ВЫ ПРОЖИВЕТЕ МНОГО СЧАСТЛИВЫХ ЛЕТ...</h1>
<h1 style="padding-left: 70px; font-family: Comic Sans MS;">ВАШ ДОМ НА КИПРЕ СКУЧАЕТ БЕЗ ВАС!</h1>
</div>
<p style="padding-left: 25px;">Иметь <strong>недвижимость на Кипре</strong> &ndash; мечта не одного миллиона человек.  Действительно, недвижимость на Кипре &ndash; это сладкая грёза, это сказка. Но сейчас вы как никогда раньше  близки к воплощению этой мечты. Ведь именно в настоящий момент застройщики Кипра готовы предложить Вам самые привлекательные условия для покупки недвижимости на Кипре! Возможно, Вас пугает оформление такой масштабной сделки?.. Вы задумываетесь  о том, удастся ли Вам обустроить свой <strong>дом на Кипре</strong> так, как Вам этого хотелось бы? Компания КупиДОМиЯ.ком с удовольствием окажет Вам профессиональную помощь в решении любых вопросов, которые связаны с недвижимостью на Кипре:</p>
<ul style="padding-left: 50px;" type="disc">
<li>аренда дома на Кипре;</li>
<li>покупка дома на Кипре;</li>
<li>оформление всех документов с переводом их на русский язык;</li>
<li>помощь в оформлении ипотечного кредита в банке Кипра (до 80% от суммы сделки)</li>
<li>помощь в обустройстве на Кипре</li>
<li>уход за недвижимостью и сдача ее в аренду на время Вашего отсутствия</li>
<li>и многое другое.</li>
</ul>
<p style="padding-left: 25px;"><strong>Купить дом на Кипре</strong> &ndash; это настолько же выгодно и престижно, насколько и реально! Многие наши соотечественники уже стали владельцами недвижимости на Кипре. И они считают, что совершили выгодное приобретение. Ведь вместе с домом на Кипре они получили несчитанное число возможностей! Собственная недвижимость на Кипре &ndash; это ключ к здоровью, долголетию, культурно насыщенной жизни и не только...</p>
<h2 style="text-align: center; font-family: Comic Sans MS;"><span style="font-size: large;">Недвижимость на Кипре &ndash; осмелься на мечту!</span></h2>
<p style="padding-left: 50px;">Возможно Вы скажете, что не всё так просто, что покупка недвижимости на Кипре или в любом другом месте &ndash; это дело очень ответственное и сложное. Спешим Вас заверить, что:  Во-первых, Вы сможете получать  профессиональные консультации  не только на протяжении всего процесса сделки, но и  в последствии. Речь идёт как о юридических вопросах, так и об особенностях и условиях жизни на Кипре. Во-вторых, прежде чем Вы примете окончательное решение о вложении средств в недвижимость на Кипре, мы готовы организовать для Вас смотровой тур. И, что важно,  в случае, если Вы решите купить дом на Кипре именно в нашей компании, мы вернём Вам деньги, потраченные на ознакомительную поездку.</p>
<p style="padding-left: 25px;">Хотите инвестировать в недвижимость на Кипре?.. Тогда Вашему вниманию мы предлагаем:</p>
<ul style="padding-left: 25px;" type="disc">
<li>дом на Кипре;</li>
<li>квартиру на Кипре;</li>
<li>мезонет на Кипре;</li>
<li>бунгало на Кипре;</li>
<li>коттедж на Кипре;</li>
<li>виллу на Кипре.</li>
</ul>
<h2 style="text-align: center; font-family: Comic Sans MS;"><span style="font-size: large;">Недвижимость на Кипре - живи как бог на острове богов!</span></h2>
<p style="padding-left: 50px;">Хотели бы вы жить в уютном домике  на берегу теплого моря?  Чувствовать прикосновение бодрящего ветра на своем лице? Встречать  повсюду только   доброжелательные счастливые лица? Хотелось бы Вам  слышать голос прибоя и  крики чаек на рассвете? Бродить по кромке воды на закате? А ночью наслаждаться звуками  &laquo;бузуки&raquo; в традиционной кипрской таверне?...</p>
<p style="padding-left: 25px;">Вы ещё раздумываете над  тем, стоит ли покупать недвижимость на  Кипре?..</p>
<p style="padding-left: 25px;">А знаете ли Вы, что купив дом на Кипре и сдавая его в аренду на время своего отсутствия, вы полностью вернете его стоимость уже через 14-16 лет?</p>
<p style="padding-left: 25px;">А знаете ли Вы, что уровень преступности на Кипре ниже, чем в любом Европейском государстве?..</p>
<p style="padding-left: 25px;">А знаете ли Вы, что мобильные телефонные звонки с Кипра, включая международную связь- одни из самых дешевых на планете?</p>
<p style="padding-left: 25px;">А знаете ли Вы, что кипрский климат признан одним из самых здоровых во всём мире?..</p>
<p style="padding-left: 25px;">И это лишь те немногие причины, которые заставляют столь многих людей задуматься о приобретении недвижимости на Кипре.</p>
<p style="padding-left: 25px;">Мы предлагаем как новое, так и  вторичное жильё, а также коммерческую недвижимость  на Кипре.</p>
<h4>Жить в доме на Кипре</h4>
<p>Как только человек становится взрослым, он тут же престает мечтать. Зачем, спрашивается, портить себе нервы и придумывать себе идеальную картину собственного будущего? Гораздо проще не обращать внимания на счастливчиков, у которых есть дом на Кипре или коттедж в Подмосковье. А между тем, дом на Кипре &ndash; это гораздо дешевле, чем жилье в Москве и Московской области. И совсем не обязательно проживать на острове круглы год: спрос на аренду недвижимости из-за большого туристического потока на Кипре просто огромный. Вы можете выбрать по собственному бюджету и вкусу</p>
<ul>
<li>дом на Кипре;</li>
<li>первичное жилье;</li>
<li>вторичное жилье;</li>
<li>участок под строительство.</li>
</ul>
<p>Если вы еще ни разу не посещали этот райский остров, который считается родиной богини любви &ndash; Венеры, то для осмотра вашего будущего дома на Кипре вам предложат смотровой тур. Если вы останетесь довольны и остановите свой выбор на вилле или доме на Кипре, то тур будет для вас абсолютно бесплатным. Но и это еще не все! Вы сможете получить поддержку от компании, которая будет вам очень нужна: перевод документации на оформление дома на Кипре в собственность, помощь при обращении в банк за кредитованием, при обстановке жилища и во многом другом.</p>
</div>',NULL,NULL);
INSERT INTO content VALUES (10000,105,NULL,NULL,'Кипр - земля легенд и грез',NULL,NULL,NULL);
INSERT INTO content VALUES (10000,106,NULL,NULL,'кипр',NULL,NULL,NULL);
INSERT INTO content VALUES (10001,102,NULL,NULL,NULL,'<p><strong>1</strong>. <strong>Консультации  по вопросам приобретения недвижимости и жизни на Кипре.<br /> </strong>Покупка  недвижимости- серьёзный шаг в жизни каждого человека, особенно приобретение  недвижимости за рубежом. Мы дадим вам исчерпывающую консультацию как по  юридическим аспектам покупки недвижимости, так и по вопросам, касающимся  условий жизни на Кипре.</p>
<p><strong>2</strong>. <strong>Смотровой  тур</strong>. <br /><img src="/upload/image/no5.jpg" alt="" width="300" height="217" align="right" /> Для просмотра и выбора недвижимости мы организуем ознакомительный тур на Кипр. Русскоговорящий сотрудник нашей компании встретит вас  и покажет интересующие вас объекты, познакомит с жизнью на острове и ответит на  все вопросы. В случае покупки недвижимости у нас, сумма, потраченная на  поездку, возвращается.</p>
<p><strong>3</strong>. <strong>Юридическая поддержка.</strong><br /> Приняв решение о приобретении  недвижимости, необходимо юридически правильно оформить сделку, соблюсти все  необходимые юридические процедуры. Для этого вы можете воспользоваться услугами  адвоката нашей компании.</p>
<p><strong>4</strong>. <strong>Уход за недвижимостью и  сдача недвижимости в аренду.</strong><strong> </strong><br /> Ваша недвижимость способна  работать на вас в ваше отсутствие. Мы можем сдавать в аренду и управлять вашей  недвижимостью. Эта услуга также включает уборку&nbsp;  за определенную плату, а также подготовку недвижимости к вашему приезду.</p>
<p><strong>5</strong>. <strong>Помощь  в приобретении обстановки для дома.<br /> </strong><img src="/upload/image/Picture-050.jpg" alt="" width="300" height="225" align="right" />Мы&nbsp; гарантируем нашим покупателям  получение&nbsp; значительных скидок при  покупке во многих магазинах Кипра мебели, бытовой техники, электроники, а также  можем обеспечить своевременную доставку этих товаров.</p>
<p><strong>6</strong>. <strong>Помощь  в получении вида на жительство.</strong><br /> Владение недвижимостью на Кипре дает право иностранцу получить вид на  жительство. Эта процедура довольно проста, но, тем не менее, требует выполнения  некоторых действий. В частности, открытия счёта в банке, посещения миграционной  службы Кипра. Наши сотрудники пройдут вместе с вами эти этапы, максимально  облегчив процесс получения вида на жительство.</p>
<p><strong>7. Все виды страхования. </strong>&nbsp;<br /> Мы  предлагаем помощь в получении всех видов страхования: от Медицинской страховки  до страхования недвижимости и автомобилей.</p>
<p><strong>8.</strong> <strong>Автомобили в аренду.</strong></p>
<p><strong>9. Регистрация компаний на  Кипре.</strong><br /> Для того, чтобы зарегистрировать бизнес на Кипре, от вас  потребуются:  анкетные данные и  переведённые на английский язык загранпаспорта учредителей и директоров, если  учредители- физические лица, и переведенные на английский язык копии уставных  документов, если учредители - юридические лица.</p>
<p><br /><br /><br /></p>
<p><img src="/upload/image/rakushka.jpg" alt="" width="580" height="425" /></p>',NULL,NULL);
INSERT INTO content VALUES (10002,102,NULL,NULL,NULL,'<p><strong>Если я  иностранец, что мне разрешено приобрести?</strong></p>
<p><img src="/upload/image/Picture-063.jpg" alt="" width="300" height="225" align="right" /> Вам разрешается приобрести:</p>
<ul>
<li>Квартиру</li>
<li>Дом </li>
<li>Участок  земли, не превышающий по площади 3 донумов,</li>
<li>Любое ограничение может быть преодолено путем регистрации кипрской компании с  ограниченной ответственностью, где более 50% акций принадлежит гражданину одной  из стран Евросоюза.</li>
</ul>
<p><strong>Что такое  номинальный залог?</strong></p>
<p>Приобретение недвижимости на Кипре не сложно, так как этот процесс  прозрачен. Покупатель делает предложение и, если оно принимается продавцом, то  первый оставляет номинальный залог в размере &euro;2000- &euro;3500, чтобы  зарезервировать за собой право на этот объект, &laquo;связать&raquo; владельца недвижимости  обязательством и &laquo;застраховать&raquo; предложенную цену от возможных скачков на  рынке. Эта процедура, в отличие от Великобритании и других стран, легально  разрешена на Кипре и не является &laquo;восточной хитростью&raquo;. Тем временем, это дает  возможность вашему адвокату осуществить необходимую подготовительную работу.  Более конкретно, он проверяет в Земельной Регистрационной Палате, не заложен ли  этот объект, не удерживается ли он за долги и нет ли иных препятствий для его  продажи.</p>
<p><strong>Подготовка контракта&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </strong></p>
<p><span style="text-decoration: underline;">Что делает адвокат?</span><br /> Ваш адвокат должен внимательно изучить ваш конкретный случай и  подготовить &laquo;индивидуальный&raquo; контракт, который максимально отражает специфику  вашей сделки. По подписании контракта покупатель должен заплатить по меньшей  мере 20%-30% от договорной цены. Остаток суммы (если таковой имеется) должен  вноситься покупателем согласно договоренности, достигнутой с продавцом.</p>
<p><span style="text-decoration: underline;">Что конкретно должно быть включено в мой контракт?</span></p>
<ul type="disc">
<li>Право продать       купленную недвижимость, если даже у вас еще нет документа, подтверждающего       право собственности,</li>
<li>Право назначать       доверенных лиц,</li>
<li>Двенадцатимесячную       гарантию качества в отношении дефектов строительства (для новостроек),</li>
<li>Ожидаемый день       передачи недвижимости в ваше пользование,</li>
<li>Раздел штрафных       санкций на случай задержки передачи объекта в ваше пользование,</li>
<li>Ожидаемый переод       времени, в который документы, подтверждающие право собственности, будут       оформлены на ваше имя.</li>
</ul>
<p><strong><img src="/upload/image/dom2.jpg" alt="" width="300" height="197" align="right" />Когда я подписываю контракт?</strong></p>
<p>Если вы еще находитесь на Кипре, к тому  времени, как контракт подготовлен, вы можете прийти в офис вашего адвоката и  подписать все необходимые документы.<br /> Если к этому времени вы уже вернулись  домой, то адвокат может выслать контракт на ваш домашний адрес курьерской  почтой.</p>
<p><strong>Кто позаботится о том, чтобы поставить  на мой контракт необходимую печать и депонировать его в Палате Регистрации?</strong></p>
<p>Как только ваш адвокат получит подписанный  вами контракт, он свяжется с застройщиком (продавцом), чтобы тот подписал контракт  со своей стороны, и произведет необходимые платежи. После этого контракт будет  доставлен в Налоговую службу для скрепления необходимой печатью, а затем  отправлен на хранение в Палату Земельной Регистрации. Контракты должны быть в  обязательном порядке скреплены печатями в течение 30 дней и сданы на хранение в  Палату Земельной Регистрации в течение 60 дней со дня подписания.  Государственные архивы надежны и конфиденциальны и не могут быть опубликованы  или доступны посторонним при любых обстоятельствах.</p>
<p><strong>Каким образом и когда я получу  свидетельство на право собственности (титул владельца)?</strong></p>
<p>Перевод права собственности на недвижимое  имущество от продавца к покупателю осуществляется через кипрскую Палату  Земельной Регистрации, как непосредственно покупателем, так и его доверенным  лицом, обладающим официальной доверенностью. Возможно, вам придется ждать  получения титула владельца в течение нескольких лет. Пусть вас не пугает это  время. Вы можете совершать любые сделки с недвижимостью, на которую ещё не получен  титул владельца. Единственное, что вы не сможете сделать, это каким-либо  образом перестроить здание.</p>
<p><strong>Какой документ подтверждает мое право  собственности на недвижимое имущество, если титул владельца еще не получен?</strong></p>
<p>Ваше право на недвижимость удостоверяет  копия договора купли-продажи с печатью Палаты Земельной Регистрации.</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p><img src="/upload/image/beach-family.jpg" alt="" width="460" height="307" /></p>',NULL,NULL);
INSERT INTO content VALUES (10003,102,NULL,NULL,NULL,'<ol>
<li><img src="/upload/image/Limassol3.jpg" alt="" width="170" height="245" align="right" />Надежное  и выгодное вложение средств (ежегодный прирост капитала составляет 10-15 %) <br /><br /></li>
<li>Система  земельной регистрации, гарантирующая неприкосновенность собственности.<br /><br /></li>
<li>Превосходный  средиземноморский климат, где 340 дней в году- солнечная погода,&nbsp; наличие свежих овощей и фруктов круглый год.<br /><br /></li>
<li>Отличная  экология.<br /><br /></li>
<li>Низкие  цены на телефонные звонки, в том числе международные.<br /><br /></li>
<li>Гарантия  безопасности (На Кипре самый низкий показатель преступности в Европе)<br /><br /></li>
<li>Прекрасные  пляжи<br /><br /></li>
<li>Высокий  уровень жизни при низком прожиточном минимуме.<br /><br /></li>
<li>Отлаженная  структура коммуникаций, улучшающаяся с каждым годом.<br /><br /></li>
<li>Доброжелательное  и отзывчивое местное население.<br /><br /></li>
<li>Возможность  получения вида на жительство в стране ЕС.<br /><br /></li>
<li><img src="/upload/image/larnaka-2.jpg" alt="" width="170" height="259" align="right" />Современные  и удобные юридические, бухгалтерские и банковские услуги, основанные на модели  Великобритании.<br /><br /></li>
<li>Долгий  летний сезон. <br /><br /></li>
<li>Возможность  сдачи в аренду имеющейся недвижимости.<br /><br /></li>
<li>Развитое  воздушное сообщение.<br /><br /></li>
<li>Прекрасное  английское образование.<br /><br /></li>
<li>На  острове есть пристани для яхт и разнообразные спортивные центры.<br /><br /></li>
<li>Дешевое ипотечное кредитование на сумму  до 80% от стоимости жилья.<br /><br /></li>
<li>Широкое распространенность русского языка  (русский- третий по распространенности на острове язык после греческого и  английского).<br /><br /></li>
<li>Гарантированная  правительством Республики Кипр конфиденциальность всех финансовых опереций и  операций с недвижимостью.<br /><br /></li>
<li>Качество  и образ жизни, всегда способствующие хорошемунастроению. <br /><br /></li>
</ol>',NULL,NULL);
INSERT INTO content VALUES (10004,102,NULL,NULL,NULL,'<p>Нисси-авеню, 28<br /> 5330 <br /> Айа-напа, Кипр.<br /> <br /> <strong><span style="text-decoration: underline;">Телефоны</span>:</strong><br /> +357 999 22 855 <br /> +357 99 824 956 <br /> <strong><span style="text-decoration: underline;"><br /> E-mail</span></strong>: <a href="mailto:info@cupidomiya.com">info@cupidomiya.com</a> <br /> <br /></p>
<div id="noborder"><img src="/images/icq.jpg" alt="" width="22" height="21" />: 488600070&nbsp; <img src="/images/scype.jpg" alt="" width="21" height="21" />:&nbsp; CUPIDOMIYA</div>
<p><br /><br /> <strong>Часы работы:</strong> 9:00 до 16:45<br /> <strong>Дни работы:</strong> Пон. - Пят.<br /> <br /> Вы также можете заполнить форму, которая  представлена справа, и мы свяжемся с Вами при первой возможности.<br /> <br /> Обращайтесь к нам, мы будем рады ответить на все ваши вопросы! &nbsp;</p>
<p>&nbsp;</p>',NULL,NULL);
INSERT INTO content VALUES (10006,102,NULL,NULL,NULL,'<p><em>Кипророжденную  буду я петь Киферею. Дарами<br /> Нежными смертных она одаряет. Не сходит улыбка<br /> С милого лика ее. И прелестен цветок на богине.<br /> Над Саламином прекрасным царящая с Кипром обширным,<br /> Песню, богиня, прими и зажги ее страстью горячей!<br /> Гомер</em></p>
<p>&nbsp;  "Прекрасноокая", "прекрасновенчанная",  "сладкоумильная"&hellip; Каких только эпитетов не было в адрес Богини любви  и красоты Афродиты. Она - само олицетворение божественной красоты и неувядаемой  юности. &hellip;Никто не мог избежать ее власти, даже боги. Высокая, стройная, с нежными  чертами лица, с мягкой волной золотых волос, как венец лежащих на ее прекрасной  голове. Как пройдет она в блеске своей красоты, в благоухающих одеждах, сразу  солнце ярче светит, и пышнее цветут цветы. Дикие лесные звери бегут к ней из  чащи леса и стаями слетаются птицы. Львы, пантеры, барсы и медведи кротко  ласкаются к ней. А души людей, при взгляде на Богиню, наполняются силой  неведомой и окрыляющей. Бродившие поодиночке люди соединяются в семьи, ибо пока  не было божественной Афродиты, не было чувства любви и привязанности друг к  другу... <br /><img src="/upload/image/mozaika-Afrodita.jpg" alt="" width="200" height="281" align="right" />&nbsp;&nbsp;&nbsp;  А родилась сия красота неземная на Средиземноморском острове Кипре, отсюда и  второе имя Афродиты - Киприда. Сам же остров до сих пор называют жемчужиной  Средиземноморья. В глубокой древности Кипр очаровывал приплывавших сюда людей  своей дивной природой.<br /> &nbsp;&nbsp;&nbsp;&nbsp;  &nbsp;Киприоты чаще всего сравнивают контуры своего острова с упавшим в море  золотисто-изумрудным листом дерева. Этот "листок" хорошо заметен с  высоты птичьего полета: многочисленные бухточки и заливы придают острову  очертания листа, зеленый цвет - от многочисленных лесов и долин, а в коричневый  - от гор.</p>
<p>Здоровье с рождения - красота на годы</p>
<p>&nbsp;&nbsp;&nbsp;  Расположение острова между тремя континентами: Европой, Азией и Африкой -  определило его природную уникальность. Климат на Кипре считается одним из самых  здоровых в мире. Лето здесь сухое и жаркое, а зима теплая, до 330 солнечных  дней в году. Зимой средняя температура +17 - +22&deg;С, летом +30&deg;С. Климат здесь  обладает уникальными антибактерицидными свойствами. Уровень инфекционного фона  экосистемы Кипра в десятки раз ниже общеевропейских показателей. Этот  экологический фактор позволяет кипрской медицине иметь практический ноль по  показателю послеоперационных осложнений инфекционного типа. Поэтому многие семейные  пары желая иметь детей здоровыми уже с рождения, специально приезжают на Кипр  для родов. А некоторые с целью регулярного оздоровления семьи строят или  покупают себе здесь дачу. Конечно, отелей здесь предостаточно, просто домашняя  обстановка больше способствует оздоровлению. В местных роддомах из каких только  стран роженицы не побывали. Много женщин и из России. Для них самое  удивительное после российских роддомовских стафилококов и постоянных  дезинфекций видеть в палате рожениц кадушки и вазы с цветами, толпы шумных  родственников, которые по очереди целуют новорожденного и легонько щипают его  щечки, между прочим, нестерильными руками. И никакой тебе ни инфекции, ни  аллергии! Вот в таком здоровом климате и родилась некогда Богиня Афродита.  По-простому, без окружения многочисленного медперсонала, вышла она на свет  божий из пены морской. Мир от ее Красоты на мгновенье замер, и покорился,  признав в ней силу божественную.</p>
<p>Целебная сила воды</p>
<p><img src="/upload/image/Afroditas-birthplace.jpg" alt="" width="300" height="222" align="right" /></p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Красота Афродиты многим представительницам прекрасного пола не дает спокойно  жить. Едут они со всех концов света к месту ее рождения вновь и вновь, надеясь  понять секрет ее очарования. Многие верят и в исцеляющую силу морских вод, что  породили Афродиту. Здесь даже существует поверье: сколько кругов проплывешь вокруг  камня Петра Ту Ромиу, возле которого и вышла на берег Богиня, на столько лет и  помолодеешь. А купаться на кипрском побережье погода позволяет девять-десять  месяцев году, это больше чем в других странах Европы в 3 раза. Море здесь  чистое и спокойное. Поэтому в купальщицах здесь недостатка нет. Особый шик  плавать возле камня ночью, тогда говорят и саму Афродиту увидеть можно. Правда,  если верить легендам, смотреть на Богиню рискованно. Увидели ее как-то  купающейся в своем гроте несколько простых смертных, и стали после этого  цветками Анютиными глазками. Так их Зевс покарал за излишнее любопытство. Зато  у кипрского царевича Адониса после такой же встречи с Афродитой в купальне,  завязался любовный роман. Знаменитая купальня Богини сохранилась и до наших дней.  Это небольшая природная ванна, тонкой струйкой в которую стекает вода со скалы.  Находится она в живописном месте среди зарослей можжевельника и фиговых  деревьев. Воду в ней местные жители называют омолаживающей, и купаться в ней  разрешают всем желающим.&nbsp; <br /> Вообще, водные процедуры целебными считаются на всем Кипре. Здесь  идеальное место для талассотерапии - самого натурального из современных методов  оздоровления и поддержания естественной красоты. Само слово  "талассотерапия" происходит от греческих "таласса" - море и  "терапия" - лечение. Суть этого метода оздоровления состоит в  использовании лечебных свойств морской воды, биоклиматических условий морского  побережья, физических упражнений и сбалансированного питания. Кипрские медики  выделяют несколько направлений лечения талассотерапией:<br /> <em>Гидротерапия</em> - лечение морской водой. Ванны и  гидромассаж. Рекомендованы при отечности, целлюлите, варикозном расширении вен.  Различные виды душа с использованием морской воды рекомендуются для повышения  тонуса, снятия судорог, стимуляции кровообращения. Эти процедуры проводятся  только на базе морской воды, подогретой до 32-35&deg;. <br /><img src="/upload/image/spa.jpg" alt="" width="300" height="255" align="right" /> <em>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Альготерапия</em> - лечение на базе морских водорослей и  грязей, богатых микроэлементами и йодом, оказывающих болеутоляющее и  антисептическое действие. Активно применяется для профилактики и лечения таких  болезней, как: артроз, остеопороз, остеохандроз, воспаление сухожилий и даже  при бессоннице. Основные процедуры: обертывания водорослями, аппликации из  водорослей, тепловые обертывания (термопотение - аппликации на основе эфирных  масел на все тело под электроодеялом; способствует выводу токсических веществ  из организма).<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <em>Кинезиотерапия</em> - массаж и лечебная  гимнастика. Основные процедуры: массаж с использованием крема на базе  водорослей, рефлексотерапия, лечебная гимнастика в воде, прессотерапия  (механическое воздействие на ноги с помощью воздуха под давлением, улучшающее  венозное кровообращение, уменьшающее отечность), ручной лимфатический дренаж.<br /> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  Курс талассотерапии рекомендуется проходить минимум 2 раза в год для  омолаживания, снятия стресса, хронической усталости, при частых респираторных  заболеваниях, в период реабилитации после травм, при заболеваниях суставов,  избыточном весе, бессоннице и в послеродовой  период.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br /> &nbsp;&nbsp;&nbsp;&nbsp;  Оздоравливаться на Кипр приезжают даже российские космонавты после полетов, а  ведущие спортсмены - на сборы перед матчами. На острове есть несколько  Реабилитационных и Косметологических СПА-Центров, в программу которых входят  уникальные новейшие методы пассивной тренировки и коррекции фигуры. Одна из  них, к примеру, была разработана на основе крио-лазеро-терапии и многоканальной  электромиостимуляции в сочетании с уникальными кипрскими белыми и голубыми  лечебными известковыми грязями.</p>
<p>Ароматерапия</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  Наверное, если бы не медь, то в названии острова Кипр обязательно было бы  название какого-нибудь цветка. Например, орхидеи, которые здесь невероятно  многообразны. Или мака, тюльпана, шафрана, ириса, розы... Кипр - одно из самых  богатых цветами мест Средиземноморья. Как и положено родине Богини-красавицы.  Любование цветами на Кипре - особая терапия для человека, столько радости и  положительных эмоций вызывают эти милые растения у людей, а иные и лечат. К  примеру, цветок адонис (анемона), названный так в честь царевича, что полюбила  Афродита, и выращенный по ее желанию из его крови, лечит нервно-психические  заболевания, приступы глаукомы, язву желудка, гастрит, почечные заболевания,  оказывает благотворное действие при отеках. А Анютины глазки, легенду о  происхождении которых мы уже вспоминали, помогают при острых респираторных  заболеваниях, воспалениях легких, бронхов, трахеи, мочевыводящих путей,  аллергических дерматитах, диатезе, экземе.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp; <img src="/upload/image/tulips.jpg" alt="" width="300" height="211" align="right" />До сих пор флора благоухающего острова не  до конца изучена, и среди цветов любознательному путешественнику могут  попасться удивительные открытия. Изученная же часть насчитывает около 1800  различных видов только цветущих растений!.. В древних легендах говорится, что у  Афродиты был чудесный пояс, в котором были заключены любовь, желание и слова  обольщения. Этот пояс источал волшебный аромат, любовной власти которого были  подчинены не только люди, но и боги. Именно с помощью пояса Богине Гере удалось  соблазнить Самого Зевса. К сожалению, нам остается лишь теряться в догадках,  что же было зашито в пояс и являлось источником покоряющего аромата любви.  Возможно, это был аромат сразу всех цветов острова? Однако попытаться  "приворожить" любимого человека с помощью афродизиаков на Кипре  вполне реально. Во всяком случае, на примере Афродиты, становится понятно, что  женская красота и обаяние не только подарок от матушки-природы, но еще и  результат собственных усилий и хитростей. Богиню-красавицу однажды даже на  Олимпе пристыдили. По одной из легенд, уличили все-таки Афродиту в употреблении  косметики: подсмотрели боги, как она лицо подкрашивала и припудривала перед  состязаниями богинь.</p>
<p>Баланс в питании - баланс в талии</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  Кто же не знает, насколько мы правильно питаемся настолько мы и красиво  выглядим? На Кипре, кажется, сразу все полезные овощи и фрукты произрастают.  Афродиту древние прославляли еще и как дарующую изобилие. В изобилии растут  здесь нектарины, персики, папайа, инжир, арахис, памела, оливы, гранат, бананы,  апельсины, лимоны, мандарины, слива. Разные цитрусовые собирают в разное время,  первый урожай в ноябре, последний - в июне. Вдоль проезжей части и тротуаров  всегда растет много мандариновых и оливковых деревьев. Почва здесь непривычного  для глаза россиян цвета - красного (краснозем). Картофель в ней растет  экстерном, урожай собирают три, а то и четыре раза в год. И обладает он при  этом какими-то особыми вкусовыми качествами, за что и заслужил честь быть уже много  десятилетий на столе у Английской королевы. В кипрской кухне главные компоненты  - лимоны и оливковое масло. На острове выделывают и самое древнее в мире вино-  Кумандарию (со времен тамплиеров, которые в свое время купили остров, затем  продали его Ричарду Львиное Сердце, а тот - французскому королю, находившемуся  в этих краях в изгнании).</p>
<p>Крепость семейных уз</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  Основное свое предназначение Богиня Афродита честно исполняет на родном острове  -&nbsp; сеет любовь в сердцах киприотов, да не мимолетную и ветренную, а ту,  что способна делать счастливыми семейные пары до самой старости. Недаром ведь  богиню называют еще и покровительницей браков и родов. Многие пары из разных  стран для брачной церемонии выбирают по этой причине именно Кипр. На острове  разводы до сих пор очень редки. Киприоты любят жить в больших каменных домах ,  часто несколько поколений семьи в одном доме. Семейные узы очень прочны. В  среднем в семье 3 ребенка. Обилие витаминов, прекрасный климат, жизнь в любви и  гармонии&hellip; Стоит ли удивляться, что здесь так высока средняя продолжительность  жизни: 82 года для женщин и 78 лет для мужчин.</p>
<p>Остров как Дом Красоты и Гармонии</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  Главным же истоком Прекрасного и Божественного на Кипре является сам остров, с  его уникальным климатом, природой и историей. Где миф и реальность - здесь  порой не различишь. "Музеем под солнцем" - еще называют его. Но то,  что Кипр был Домом Афродиты, это факт. Может, в этом и есть главный секрет  Богини-красавицы? И чтобы приблизиться к волшебству ее чар и обрести вечную  молодость, надо для начала приобрести дом на Кипре? Пока о такой мотивации  покупки недвижимости на острове сведений нет, все больше покупатели говорят о  преимуществах здорового климата, условий проживания и выгодных инвестициях. Но  возможно, у них просто не хватает смелости признаться, что едут на Кипр за  Красотой, Гармонией и Любовью. Не принято, к сожалению, в нашем  технократическом обществе публично признаваться в своих чувствах и тайных  желаниях. Зато по-прежнему модно быть здоровым и красивым! Так вперед, в  объятья Афродиты! Возможно, именно Вам она подарит на своем острове-доме не  только Здоровье и Красоту, но и Любовь!</p>
<p>&nbsp;</p>
<p><em>По материалам журнала&nbsp; &laquo;Красота и Здоровье&raquo;</em></p>
<p><em>&nbsp;</em></p>
<p><img src="/upload/image/girl-on-the-beach.jpg" alt="" width="580" height="435" /></p>',NULL,NULL);
INSERT INTO content VALUES (10007,102,NULL,NULL,NULL,'<ul>
<li><a style="color: #003399;" href="#1">Верблюжий парк</a></li>
<li><a style="color: #003399;" href="#2">Сафари на осликах</a></li>
<li><a style="color: #003399;" href="#3">Горнолыжные виды спорта</a></li>
<li><a style="color: #003399;" href="#4">В путешествие по горным деревням</a></li>
<li><a style="color: #003399;" href="#5">Парк рептилий</a></li>
</ul>
<h1 style="padding: 15px 0px;"><a name="1"></a>Верблюжий парк</h1>
<p><strong><img src="/upload/image/v-shlyape.jpg" alt="" width="200" height="136" align="right" />Недалеко от деревни Мазотос, что на  старой дороге между Ларнакой и Лимассолом, расположился единственный на Кипре верблюжий парк.  В зимнее время он ежедневно открыт для посетителей с 9 утра до 5, а летом до 7  часов вечера. Это редкое место, где одинаково счастливо и весело чувствуют себя  и взрослые и дети.</strong><br /> Зайдя в парк, все сначала устремляются  к загонам с верблюдами. И это неудивительно- необычные животные с гордо  поднятой головой притягивают внимание всех посетителей. Многие с опаской стоят  поодаль- кто знает, что у этого верблюда на уме? Не стоит бояться. Верблюд-  очень спокойное животное, вам гораздо легче его напугать, чем вызвать агрессию.  Исключением являются лишь верблюдицы с детёнышами- если верблюдица решит, что  её малышу грозит опасность, она защищает его с необыкновенной отвагой. Кстати,  эти животные обожают стручки рожкового дерева. Мешочек с рожками вы можете  купить у входа в парк и покормить верблюдов и их детёнышей.<br /> Самые храбрые могут совершить прогулку  верхом на верблюде. Для этого необходимо купить билет у входа  в парк. Погонщик поможет вам усесться в седло и подскажет, как правильно себя  вести, когда верблюд будет подниматься с колен, а затем, по окончании прогулки,  опускаться, давая вам возможность сойти с него.<br /><img src="/upload/image/verbludochka.jpg" alt="" width="200" height="150" align="right" /> В парке вы встретите не только  верблюдов. Страусы, козы, мулы, лошади- это лишь немногие обитатели весёлого  парка. Как говорится, каждой твари по паре, как было в Ноевом ковчеге, макет  которого вы увидите в центре поселения животных.<br /> А еще в парке есть детская площадка,  бассейн, бар, ресторан и даже небольшой дом-музей, в котором представлены  предметы быта бедуинов. Среди них вы с удивлением обнаружите и старую печатную  машинку, и русскую шапку-ушанку. В общем, быт бедуинов поразит вас  разнообразием&hellip;<br /> Верблюжий парк может стать местом  проведения детских праздников и дней рождения.</p>
<p>Билеты:  3 евро- взрослый, 2 евро детский, покататься на верблюде- 6 евро</p>
<p>Телефон парка:  24 991243.<br /> Страничка в  интернете: www.camel-park.com</p>
<p>&nbsp;</p>
<p><em>По материалам журнала  &laquo;Магазины Кипра&raquo; №24 (зима 2008-2009)</em></p>
<p><em>&nbsp;</em></p>
<p><em>&nbsp;</em></p>
<h1 style="padding: 15px 0px;"><a name="2"></a>Сафари  на осликах</h1>
<p><strong>Сафари на осликах- это уникльная  возможность отправиться в путешествие в прошлое Кипра и познакомиться с  традиционной деревенской культурой, о которой мы, в большинстве своём жители  городов- почти ничего не знаем.</strong></p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <img src="/upload/image/osly.jpg" alt="" width="200" height="150" align="right" />Узкая дорога, петляя по полям с  цитрусовыми и оливковыми рощами, приведёт к  стильно оформленной деревенской ферме. Все постройки выполнены из белого камня.  Высушенные тыквы, покачиваясь на ветру, издают уютный шелест. А вы знаете, что  если вы будете хранить в своём доме высушенную тыкву и периодически её  встряхивать, то деньги в доме никогда не переведутся? Народная примета!<br /> Обязательно загляните в этнографический  музей, оформленный в виде традиционного кипрского дома. Не многие из нас  представляют, какой была жизнь местных жителей всего несколько десятилетий  назад. А детям доставит удовольствие прогулка по ферме, где кроме осликов живут  ещё и длинноухие кипрские козы, которых можно покормить стручками рожкового дерева. <br /> В местной лавочке некоторые из вас  впервые попробуют настоящие кипрские деликатесы. Например, разные сорта  оливкового масла: с лимоном, мятой, бергамотом... А некоторые откроют для себя  сироп рожкового дерева, регулярное употребление которого способствует излечению  от желудочно-кишечных заболеваний, способствует нормализации уровня железа в  организме и является великолепным средством, предупреждающим остеопороз!<br /> Прежде, чем начнётся главное  приключение дня- сафари на осликах, вас научат, как держаться на осликах и как  управлять этими симпатичными, но своенравными животными. Кстати, путешествие  будет записываться на видеокамеру, а диск с весёлым фильмом, если пожелаете,  сможете купить чуть позже. В конце поездки вас ждёт еще один сюрприз: вы прошли  школу по вождению ослов и теперь имеете право получить &laquo;права ословодителя&raquo;!<br /> <img src="/upload/image/zakus.jpg" alt="" width="200" height="313" align="right" />По возвращении на ферму вас пригласят  на традиционный кипрский ужин: салат,  деревенские оливки, мясо на гриле, ну и конечно домашнее вино и зивания. А  после ужина зазвучит любимая всеми мелодия &laquo;Сиртаки&raquo; и на сцену выйдут кипрские  добры молодцы. Белоснежная рубашка, чёрные шаровары, перетянутые широким  поясом, озорной блес карих глаз и отточенные движения неторопливого танца,  плавно переходящего в сумасшедшую пляску. В конце выступления профессионалов на  сцену приглашаются все желающие научиться этому красивому древнему танцу. Кто  из нас, даже по нескольку лет проживших на Кипре, может уверенно и точно  исполнить все &laquo;па&raquo;? Поэтому этот вечер для вас еще и прекрасная возможность  научиться этим завораживающим движениям у профессионалов.<br /> Этот день запомнится вам и вашим детям!</p>
<p>Записаться на  сафари на осликах можно по телефону: 24 812990.</p>
<p><em>По материалам журнала  &laquo;Магазины Кипра&raquo; №24 (зима 2008-2009)</em></p>
<p><em>&nbsp;</em></p>
<p><em>&nbsp;</em></p>
<h1 style="padding: 15px 0px;"><strong><a name="3"></a>Горнолыжные виды спорта</strong></h1>
<p><strong>Бешеная скорость, полная  тишина, не считая пронзительного свиста ветра и ударов собственного сердца, и  ты один на один с природой. Потрясающие ощущения и море положительных эмоций.  После такой встряски и выброса адреналина все проблемы остаются позади, и  хочется жить &laquo;на всю катушку&raquo;.</strong><br /> <br /> <img src="/upload/image/gorn-ligi.jpg" alt="" width="200" height="179" align="right" />Лыжный сезон на Кипре  длится с декабря до начала апреля. Гарантированный снежный покров обеспечивают  три специальные установки, производящие искусственный снег. Горнолыжные трассы  находятся на склонах горы Олимп (1951 м над уровнем моря), каждый склон имеет  своё имя. Например, Зевс и Гера, расположенные в северной части Олимпа,  предназначены для продвинутых лыжников. Начинающим лучше отправиться на склоны  Афродита и Гермес.</p>
<p><strong>Покупка и прокат инвентаря</strong></p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Лыжи можно взять  напрокат в Cyprus Ski Club или приобрести экипировку в магазине, который  находится на склоне &laquo;Солнечная долина&raquo;. Его обслуживают профессиональные  спортсмены. Здесь вы можете приобрести лыжи, ботинки, палки- как для горных,  так и для беговых лыж.<br /> Федерация лыжного  спорта Кипра разработала систему скидок для временных членов лыжных клубов.  Чтобы стать членом Cyprus Ski Club, необходимо обратиться в один из филиалов  клуба в Лимассоле, Никоссии, Фамагусте или Троодосе.</p>
<p><strong>Обучение</strong></p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; В лыжной школе  преподают инструкторы-профессионалы, уроки для начинающих проводятся три раза в  день по полтора часа. Вы также можете нанять индивидуального инструктора. Какое  количество часов в день оптимально для обучения? Как правило, достаточно 3-4  часов. Урок в группе обойдётся вам в 15 евро (для детей 10). Индивидуальный  урок стоит 35 евро (для детей 25).</p>
<p><strong>Трассы и подъёмники</strong></p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Горнолыжные курорты  оцениваются не только по ухоженности и количеству трасс, но и по качеству и  суммарной мощности подъёмников. Всего на Олимпе 12 трасс разного уровня  сложности- от очень лёгких до полупрофессиональных. Работают четыре двухместных  бугельных подъёмника- ежедневно с 8.30 до 16.00. Длина первого из подъёмников  на северных склонах Олимпа-364 м, пропускная способность- 400 лыжников в час,  второй подъёмник чуть меньше: длина- 260 м, пропускная способность 344 лыжника  в час.</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Статистика  утверждает, что человек, хоть раз побывавший на горнолыжном курорте, в 9 из 10  случаев вернётся на заснеженные горы. Они становятся будто наркотиком, маня  своей суровой красотой, потрясающими закатами, голубым небом и алмазными  брызгами снежных бургунов, вырывающихся из-под лыж в ослепительном блеске  солнца.</p>
<p><strong>Аренда лыж и  обмундирования:</strong></p>
<p>Лыжи-ботинки-палки:<br /> Взрослые- на весь день- &euro; 16<br /> После 13.00- &euro; 12</p>
<p>Дети- на весь день- &euro; 13<br /> После 13.00- &euro; 9</p>
<p>Сноуборды- на весь день- 20 &euro;</p>
<p><strong>Горнолыжный подъёмник:</strong></p>
<p>На весь день-&nbsp; &euro;23<br /> После 13.00-&nbsp; &euro;16</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br /> Владельцам карты Cyprus Ski Club предоставляется скидка 25% на  указанные цены.</p>
<p><strong>Полезные телефоны:</strong><br /> Лыжная школа OLYMPUS: 99 428116, 25 720309<br /> Лыжная школа &Tau;ROODOS: 99 443450<br /> Кипрская лыжная школа: 99 516590</p>
<p>Дополнительная информация на www.skicyprus.com&nbsp;</p>
<p>&nbsp;</p>
<p><em>По  материалам журнала &laquo;Магазины Кипра&raquo; №24</em></p>
<p><em>&nbsp;</em></p>
<p>&nbsp;</p>
<h1 style="padding: 15px 0px;"><strong><a name="4"></a>В путешествие по  горным деревням</strong></h1>
<p><strong>Если вы проедете вглубь острова, то  обязательно окажетесь в одной из горных деревушек, застроенных старинными  каменными домами, которые практически не менялись на протяжении веков.  Остановившись в самом сердце кипрской деревни, вы сможете окунуться в  неторопливый ритм местной жизни. В дополнение к незабываемым впечатлениям  существует ещё одно немаловажное достоинство этого вида отдыха- вполне  доступные цены.</strong><br /> В живописных деревнях гостей ждут  уютные старинные дома, с любовью отреставрированные и оформленные в  национальном стиле. Все они обставлены традиционной кипрской мебелью и зачастую  имеют сад, просторный двор или террасу. Чтобы действительно оценить прелесть  деревенской жизни, советуем остановиться в одной из них как минимум на три дня.</p>
<p><strong><img src="/upload/image/agros.jpg" alt="" width="300" height="174" align="right" />Агрос (Agros village)</strong></p>
<p>Район, в котором  расположена деревня Агрос, называется Питцилия и лежит в восточной части  Троодосской гряды. Здесь просто раздолье для любителей пеших прогулок. В мае,  когда цветут розы, в небольшом доме на окраине села методом перегонки  изгатавливают розовую воду, которую затем на протяжение всего года можно купить  в деревне. Эта вода используется при выпечке кондитерских изделий. Кроме  розовой воды здесь делают очень вкусный розовый ликёр и розовое бренди, для  получения которого опускают лепестки роз в спирт и выставляют его на солнце.  Эта продукция разливается как в обычные стеклянные бутылки, так и в  керамические- прекрасный сувенир в память о солнечном острове.<br /> Если вы хотите сэкономить примерно 30%  от цены, да ещё и увидеть, как изготавливается эта вкусная продукция,  отправляйтесь прямо на место производства- этот дом находится на Anapavseos  Avenue, а фирма называется Chris N.Tsolakis. На улицах деревни вы почти  наверняка увидите таблички, указывающие нужное направление. Хозяева этого  мини-производства с удовольствием покажут вам, как делается розовая вода.<br /> Агрос славен не только розовой водой. В  магазинчике Kafkalia предлагаются великолепные мясные изделия: лунза (loyntza)-  свиное мясо, которое, прежде чем помещается в коптильню, несколько дней  вымачивается в вине с добавлением кориандра, луканика (loykanika)- свиные  сосиски с перцем и прочими специями, хиромери (&chi;oiromeri)- копчёная свинина, вымоченная в  винном соусе. Все копчёности изготавливаются здесь же, в магазине и вам покажут  коптильню, если вы этого пожелаете.</p>
<p><strong>Омодос (Omodos Village)&nbsp; </strong></p>
<p>Эта живописная  деревушка словно специально создана для того, чтобы по её узким и аккуратным  улочкам бродили туристы. Здесь вам предложат местную вышивку, изделия из стекла  ручной работы, сладости (маленькие мандарины в сиропе, засахаренные орехи,  инжир, финики, шушукос). Но главное, чем знаменита деревня- это вино. Марки  &laquo;Линос&raquo;, &laquo;Марион&raquo;, &laquo;Херолимо&raquo; ценятся и киприотами, и гостями острова. Вы  сможете попробовать также вино домашнего приготовления- оно здесь превосходное.  Вы увидите пресс- давильню, где перерабатывают виноград, и агрегат для  приготовления кипрской &laquo;огненной воды&raquo;- зивании. <br /> В деревне есть собственный музей- в  доме Сократа Сократуса представлен традиционный интерьер кипрского сельского  дома. А на улочке ниже деревенской площади, у дома, где дети охотно  сфотографируются с маленьким осликом, старый Костас готовит вкуснейшую питту-  тонкостенную лепёшку с мясом и свежими овощами. В Омодос ведёт много дорог, но  сами киприоты рекомендуют ту, которая проходит через наиболее впечатляющие  ландшафты. Чтобы попасть на неё, надо проехать по прибрежной дороге Лимассол-  Пафос и на отрезке пути между деревнями Куклия (Kouklia) и Мандрия (Mandria)  повернуть в горы, в направлении Никоклеа (Nikokleia), Героваза (Gerovasa) и  далее мимо Малии (&Mu;alia)  на Орнодос (Ornodos).</p>
<p><strong><img src="/upload/image/kakop.jpg" alt="" width="300" height="225" align="right" />Какопетрия (Kakopetria Village)</strong></p>
<p>Эта лежащая в  северных предгорьях Троодоса деревня особенно любима жителями столичной  Никоссии, которые в выходные дни приезжают в Какопетрию, чтобы хотя бы на время  на ее зелёных тенистых улочках забыть о царящей в городе жаре. Здесь есть всё  для отдыха: несколько небольших отелей, великолепная природа и прекрасные  рестораны, в которых одним из самых популярных блюд является приготовленная под  вкуснейшим соусом форель (pestrofa). В центре деревни, сразу за рестораном The  Village Pab &amp; Restorant, находится &laquo;плохой камень&raquo;, который и дал название  деревне. Согласно преданию, в старину вступавшие в брак молодожёны должны были трижды  обежать этот камень. Однажды очередная пара молодоженов, обежав камень, упала  замертво- с тех пор камень нарекли &laquo;плохим&raquo;. Пройдите по мощеной улочке,  ведущей от камня вверх, и вы увидите жизнь деревни. Рядом с Какопетрией есть  ещё одна достопримечательность- церковь Айос Николаос тис Стегис (Agios  Nikolaos tis Stegis), построенная в &Chi;&Iota; в. Это типично византийская церковь той эпохи, украшенная  фресками.</p>
<p><strong>Галата (Galata Village)</strong></p>
<p>Расположена в  километре к северу от деревни Какопетрия. Здесь тоже любят отдыхать киприоты.  Достопримечательностью деревни являются четыре церкви, две из которых &ndash; Панагия  Подиту (Panagia Podithou) и Панагия Теотокос (Panagia Theotokos)- построены в &Chi;VI в, в их росписи прочитываются не  только византийские мотивы, и они представляют особый интерес. Церковь Панагия  Подиту включена в список всемирного наследия ЮНЕСКО.</p>
<p><strong>Пано Платрес&nbsp;  (Pano Platres Village)</strong></p>
<p>Две деревни с  похожими названиями- Пано Платрес и Като Платрес- находятся поблизости друг от  друга, у горной дороги, пролегающей через Троодос на высоте около 1100 метров  над уровнем моря. Когда говорят &laquo;Платрес&raquo;, имеют в виду Пано Платрес. Именно  здесь еще в начале XX века англичане стали создавать курорт для отдыха  сотрудников колониальной администрации. Высокогорная деревня в окружении  сосновых и кедровых лесов подходила для этих целей как нельзя лучше. Прелести  горного курорта оценили и представители элиты Ближнего Востока, которые  отдыхали в этих местах после ухода с острова англичан. Сегодня же Платрес  доступен всем. Отели категорий от одной до четырёх звёзд, прекрасная природа,  более низная, по сравнению с равнинным Кипром температура воздуха, а зимой- с  января по март, еще и возможность покататься на лыжах- всё это привлекает людей  в Платрес. Здесь можно увидеть, как разводят форель (это место называется Псило  Дэндро), или совершить прогулку к красивому Каледонскому водопаду (Kaledonian Falls).</p>
<p><strong>Долина Маратасса (&Mu;arathassa).</strong></p>
<p>Долина Маратасса  представляет собой велеколепный ландшафт. Она простирается на северном склоне  горного массива Троодос. Здесь цветут великолепные вишнёвые сады, которые  весной похожи на бело-розовые облака. Очаровательные пейзажи подарят вам  незабываемые ощущения и эмоции. Здесь множество небольших горных деревушек,  которые рассыпаны по склону гор. Здесь всегда есть, где остановиться.</p>
<p><strong>Добро пожаловать в горные деревни Кипра-  в места, где живёт покой...</strong></p>
<p><strong>&nbsp;</strong></p>
<p><em>По  материалам журнала &laquo;Недвижимость на Кипре&raquo; №5 2007г.</em></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<h1 style="padding: 15px 0px;"><a name="5"></a>ПАРК РЕПТИЛИЙ</h1>
<p><strong>По преданию, в IV веке святая Елена привезла на остров целый  корабль кошек. Они должны были избавить Кипр от змей, которых после многолетней  засухи на острове расплодилось великое множество. &laquo;К счастью, Елене так и не  удалось уничтожить всех змей острова&raquo;, &mdash; говорит 63-летний австриец,  проживающий на Кипре более 20 лет. Зовут его Ханс-Йорг Вьедль. Но он давно уже  привык к другому прозвищу, данному ему киприотами, &mdash; Джордж-змей. Те местные  жители, которые без содрогания не могут смотреть на пресмыкающихся, называют  его &laquo;безумным Йоргосом&raquo;. </strong><br /> Впервые он оказался на  Кипре в составе миротворческого контингента войск ООН в 1973 году. За 15  месяцев своего пребывания ему удалось хорошо познакомиться с островом и обрести  здесь друзей. Контракт на Кипре окончился, и Вьедль в составе &laquo;голубых касок&raquo;  отправился в следующую страну. Однако вскоре он подорвался на мине и, получив  ранение, был вынужден выйти на пенсию. Ханс-Йорг устроился работать госслужащим  на родине. В 1986 году австриец решил осесть на Кипре и посвятить остаток своей  жизни пресмыкающимся. <br /> &mdash; На Кипре существует  такая поговорка: &laquo;Хорошая змея &mdash; мертвая змея&raquo;, &mdash; рассказывает Джордж. &mdash; Людей  здесь не интересует, что из восьми видов змей только три относятся к категории  ядовитых, и укус лишь одной из них опасен для жизни человека, да и то &mdash;  исключительно в том случае, если на змею наступить. <br /> В 1996 году Джордж-змей  основал на Кипре парк рептилий, основная задача которого &mdash; знакомить жителей и  гостей острова с жизнью змей, ящериц и лягушек. Познания Вьедля о мире рептилий  и амфибий, полученные в годы учебы и пребывания в пустынях и джунглях, помогли  ему создать на острове парк рептилий под открытым небом. Здесь каждый желающий  получает возможность наблюдать за жизнью земноводных в условиях, максимально  приближенных к их естественной среде обитания. Служащие парка рассказывают о привычках  и особенностях каждого из более чем 100 его обитателей. &laquo;Змеи &mdash; важная часть  нашей экологии, и их защита &mdash; прямая обязанность каждого из нас&raquo;, &mdash; гласит  плакат на территории парка. Безопасность посетителей парка гарантирована: для  ядовитых змей сделаны специальные загоны, которые не позволяют им оказаться на  пешеходных дорожках. За время существования парка его посетили более 10 тысяч  человек. Из них 95% &mdash; иностранцы. <br /> &mdash; Я задумывал парк для  киприотов, но они не хотят приходить. Они мне говорят: &laquo;У тебя должны быть  большие змеи: питоны, гремучие змеи, кобры, &mdash; именно их хотят увидеть люди&raquo;. Но  киприоты ничего не знают о змеях Кипра! &mdash; недоумевает Джордж-змей. <br /> Он до сих пор шокирован  нелюбовью киприотов к змеям. Он признает, что еще 50 лет назад местные жители  считали всех змей острова ядовитыми, т.к. в те времена не было противоядия, и  никто не мог помочь человеку, укушенному ядовитой змеей. Но сейчас, считает  Джордж, нет причин для страха. <br /> &mdash; Змеи никогда не  нападают, они лишь защищаются, &mdash; утверждает владелец парка рептилий. &mdash; Вы не  убедите меня в том, что людей нельзя научить не бояться змей. Мы же выучили,  что красный свет означает, что нужно остановиться. Тогда почему же люди не  могут узнать больше о змеях, как это происходит в Австрии, где этому учатся с  детства. <br /> Одним из самых  выдающихся успехов Джорджа стало открытие на Кипре травяного ужа, который в  течение последних 40 лет считался исчезнувшим видом. В 2002 году г-н Вьедль  выпустил иллюстрированную книгу о змеях Кипра. В парк к Джорджу-змею на стажировку  приезжают студенты из Англии, Германии, Голландии и США. В 1998 году за  выдающиеся заслуги в сфере защиты и сохранения популяции змей Кипра Ханс-Йорг  Вьедль был награжден Почетным крестом в области искусства и науки, врученным  президентом Австрии. Французское телевидение в рамках документального сериала о  природе сняло об австрийце фильм &laquo;Джордж и змеи Кипра&raquo;, который вот уже 12 лет  с успехом демонстрируется крупнейшими каналами мира. В течение многих лет  Джордж-змей пытается убедить местные телеканалы и газеты отказаться от  демонстрации видео- и фотокадров с изображением мертвых или умирающих змей.  Вместо этого кипрский серпентолог готов появляться на экранах телевизоров и  страницах газет и рассказывать о пользе змей для экосистемы острова и о том,  что они не представляют опасности для людей. <br /> Змеи &mdash; наши друзья,  считает Джордж. <br /> <strong>Часы работы парка рептилий</strong> &mdash; с 9.00 и до заката солнца<br /> <br /> Тел. 26 938160, моб. 99-987685<br /> <a style="color: #003399;" href="mailto:snakegeorge@hotmail.com">snakegeorge@hotmail.com</a><br /> Веб-сайт: <strong><a style="color: #003399;" href="http://www.snakegeorge.com" target="_blank">www.snakegeorge.com</a></strong> <br /> <strong>Как доехать </strong><br /> От Пафоса &mdash; по дороге в  Агиос Георгиос, проезжаем Корал-Бэй, перед заправкой ESSO, расположенной справа  от дороги, поворачиваем направо (в противоположную от моря сторону). Парк  расположен за заправкой.<br /> Схему проезда можно посмотреть на сайте <strong><a style="color: #003399;" href="http://www.snakegeorge.com" target="_blank">www.snakegeorge.com</a></strong></p>
<p><em>Источник: </em><em>http</em><em>://</em><em>www</em><em>.</em><em>evropa</em><em>-</em><em>kipr</em><em>.</em><em>com</em><em>/</em><em>main</em><em>/</em><em>a</em><em>_</em><em>more</em><em>.</em><em>php</em><em>?</em><em>id</em><em>=1645_0_1_0_</em><em>M</em></p>
<p>&nbsp;</p>',NULL,NULL);
INSERT INTO content VALUES (10008,102,NULL,NULL,NULL,'<p>Вы решили провести  некоторое время на острове, но у Вас нет никакой недвижимости на Кипре?.. Отдых в туристическом формате, деловая  поездка или любой другой повод &ndash; что бы ни было причиной Вашего приезда, перед  Вами непременно встанет вопрос о выборе места жительства. Самым привлекательным  вариантом, бесспорно, является аренда  дома на Кипре. Ведь какими бы удобными ни были гостиницы, они не смогут  приблизить Вас к ощущению своего дома на  Кипре. Очевидно, что дом на Кипре,  пусть и не собственный, пусть арендованный, подарит Вам свободу, столь важную  для любой поездки. Не исключено, что именно после такой поездки, ощутив себя  как дома и оценив все преимущества жизни на острове, Вы захотите купить дом на Кипре.</p>
<p>Для того чтобы организовать аренду дома на Кипре, достаточно  связаться с консультантом КупиДОМии и выбрать подходящие апартаменты. Под арендой дома на Кипре мы понимаем  предоставлении самого разного, но неизменно комфортабельного жилья: от  квартиры-студии до виллы класса люкс.</p>
<p>Если Вы воспользуетесь  нашей услугой по организации аренды дома  на Кипре, комфорт будет Вам обеспечен. Мы не только организуем аренду домов на Кипре, но также и  аренду вилл и отдельных апартаментов. В любом случае в Вашем распоряжении будут  все удобства (аудио, видео и бытовая техника, бассейн и т. д.).</p>
<p>Мы можем предложить Вам недвижимость на Кипре любого уровня.  Вам необходимы апартаменты для двоих со всеми удобствами?.. Мы предоставим  Вам широкий выбор. Вы хотите виллу с частным бассейном, патио и местом для  барбекю &ndash; пожалуйста. Мы готовы не только организовать для Вас аренду дома на Кипре, но также и  трансфер из аэропорта.</p>
<p>Мы занимаемся не только  организацией аренды домов на Кипре,  но также ведём активную деятельность по купле-продаже недвижимости на Кипре.</p>
<p>Итак, КупиДОМиЯ  предлагает:</p>
<ul type="disc">
<li>взять в аренду       дом на Кипре;</li>
<li>купить дом       на Кипре.</li>
</ul>
<p>Любые услуги мы оказываем  качественно. Это значит, что мы готовы предоставить необходимое юридическое  сопровождение и помочь в разрешении любых возникающих вопросов.</p>',NULL,NULL);
INSERT INTO content VALUES (10009,120,NULL,NULL,NULL,'Описание ленты/категории новостей.',NULL,NULL);
INSERT INTO content VALUES (10010,121,NULL,NULL,NULL,'Анонс новости №1.',NULL,NULL);
INSERT INTO content VALUES (10010,122,NULL,NULL,NULL,'Основной текст новости №1.',NULL,NULL);
INSERT INTO content VALUES (10010,124,NULL,NULL,'2010-05-30',NULL,NULL,NULL);
INSERT INTO content VALUES (10011,121,NULL,NULL,NULL,'Анонс новости №2.',NULL,NULL);
INSERT INTO content VALUES (10011,122,NULL,NULL,NULL,'Основной текст новости №1.',NULL,NULL);
INSERT INTO content VALUES (10011,124,NULL,NULL,'2010-06-01',NULL,NULL,NULL);


-- -----------------------------------------------------
-- Data for table permissions_modules
-- -----------------------------------------------------

INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 2, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 17, 'view', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 19, 'view', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 20, 'view', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 24, 'view', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 26, 'view', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 28, 'view', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 1, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 3, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 4, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 5, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 6, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 7, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 8, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 9, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 10, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 11, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 12, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 13, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 14, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 15, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 16, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 17, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 18, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 19, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 20, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 24, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 25, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 26, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 27, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 28, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 1, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 3, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 4, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 5, '', 1);
-- INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 6, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 7, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 12, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 13, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 14, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 15, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 16, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 17, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 18, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 19, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 20, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 25, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 27, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (4, 28, '', 1);

-- -----------------------------------------------------
-- Data for table registry
-- -----------------------------------------------------

INSERT INTO registry (var, val) VALUES('site_name','s:108:"Дом на Кипре - это не роскошь! Мы поможем Вам его приобрести.";');
INSERT INTO registry (var, val) VALUES('site_description','s:108:"Дом на Кипре - это не роскошь! Мы поможем Вам его приобрести.";');
INSERT INTO registry (var, val) VALUES('site_keywords','s:0:"";');
INSERT INTO registry (var, val) VALUES('use_urlnames','s:1:"1";');
INSERT INTO registry (var, val) VALUES('modules_order','a:7:{i:0;s:5:"admin";i:1;s:4:"data";i:2;s:4:"menu";i:3;s:4:"news";i:4;s:9:"templates";i:5;s:5:"users";i:6;s:5:"trash";}');
INSERT INTO registry (var, val) VALUES('artic_active','s:1:"1";');



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
