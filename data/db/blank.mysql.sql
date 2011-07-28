SET FOREIGN_KEY_CHECKS=0;
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


CREATE TABLE IF NOT EXISTS `blocks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_object` int(11) NOT NULL DEFAULT '0',
  `filename` varchar(64) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `filename` (`filename`),
  KEY `title` (`title`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=4 ;

--
-- Дамп данных таблицы `blocks`
--

INSERT INTO `blocks` (`id`, `id_object`, `filename`, `title`) VALUES(1, 14, '1290093098', 'Новости');
INSERT INTO `blocks` (`id`, `id_object`, `filename`, `title`) VALUES(3, 0, 'fos', 'fos');

-- --------------------------------------------------------

--
-- Структура таблицы `content`
--

CREATE TABLE IF NOT EXISTS `content` (
  `id_obj` int(10) unsigned NOT NULL,
  `id_field` int(10) unsigned NOT NULL,
  `val_int` bigint(20) DEFAULT NULL,
  `val_float` float DEFAULT NULL,
  `val_varchar` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `val_text` mediumtext CHARACTER SET utf8,
  `val_rel_obj` int(10) unsigned DEFAULT NULL,
  `val_rel_elem` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_obj`,`id_field`),
  KEY `fk_content_objects` (`id_obj`),
  KEY `fk_content_fields` (`id_field`),
  KEY `fk_rel_object` (`val_rel_obj`),
  KEY `fk_rel_element` (`val_rel_elem`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `content`
--

INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(5, 148, NULL, NULL, 'Забузякин', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(5, 149, NULL, NULL, 'dmitry.k@fabricasaitov.ru', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(5, 154, NULL, NULL, NULL, 'ул.Быборгская 15 ', NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(5, 168, NULL, NULL, '+7-911-54541111', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(1000, 22, NULL, NULL, 'main', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(1000, 111, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10000, 102, NULL, NULL, NULL, '<p>Повышение жизненных стандартов, не меняя концепции, изложенной выше, настроено позитивно. Побочный PR-эффект переворачивает SWOT-анализ, осознав маркетинг как часть производства. Бренд индуктивно определяет портрет потребителя, не считаясь с затратами. Таргетирование детерминирует направленный маркетинг, невзирая на действия конкурентов.</p>\n<p>Итак, ясно, что бизнес-модель инновационна. Согласно&nbsp;ставшей уже классической работе Филипа Котлера, повышение жизненных стандартов экономит потребительский рынок, повышая конкуренцию. Несмотря на сложности, рекламное сообщество масштабирует рекламный блок, работая над проектом. Потребительский рынок стремительно восстанавливает контент, отвоевывая свою долю рынка.</p>\n<p>Побочный PR-эффект обычно правомочен. Производство неверно концентрирует из ряда вон выходящий системный анализ, расширяя долю рынка. Диктат потребителя, пренебрегая деталями, ригиден как никогда. Презентация требовальна к креативу. Взаимодействие корпорации и клиента поразительно. Стратегический рыночный план,&nbsp;конечно, притягивает бренд, осознав маркетинг как часть производства.</p>\n<!-- block(fos) -->', NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10000, 104, NULL, NULL, 'Главная пере_главная', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10000, 105, NULL, NULL, 'Главная пере_главная', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10000, 106, NULL, NULL, 'Главная пере_главная', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10000, 107, NULL, NULL, 'Главная пере_главная', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10025, 154, NULL, NULL, NULL, 'qwe', NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10025, 168, NULL, NULL, '123', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10041, 102, NULL, NULL, NULL, '', NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10041, 104, NULL, NULL, 'Регистрация', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10041, 105, NULL, NULL, 'Регистрация нового пользователя', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10049, 104, NULL, NULL, 'Кукушечки', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10049, 105, NULL, NULL, 'Личный кабинет', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10058, 102, NULL, NULL, NULL, '', NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10061, 199, 0, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10062, 199, 500, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10152, 199, 300, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10157, 199, 50, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10204, 187, NULL, NULL, 'all', NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10220, 182, 1, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `content` (`id_obj`, `id_field`, `val_int`, `val_float`, `val_varchar`, `val_text`, `val_rel_obj`, `val_rel_elem`) VALUES(10220, 185, NULL, NULL, NULL, 'a:1:{i:0;s:5:"10204";}', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `elements`
--

CREATE TABLE IF NOT EXISTS `elements` (
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
  `urlname` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
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
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=137 ;

--
-- Дамп данных таблицы `elements`
--

INSERT INTO `elements` (`id`, `id_parent`, `id_type`, `id_obj`, `id_lang`, `id_tpl`, `id_menu`, `is_active`, `is_deleted`, `is_default`, `urlname`, `updatetime`, `ord`) VALUES(1, NULL, 17, 10000, 1, 0, 1000, 0, 0, 1, 'Главная_пере_главная', '2011-07-13 16:55:11', 13);
INSERT INTO `elements` (`id`, `id_parent`, `id_type`, `id_obj`, `id_lang`, `id_tpl`, `id_menu`, `is_active`, `is_deleted`, `is_default`, `urlname`, `updatetime`, `ord`) VALUES(2, NULL, 31, 10001, 1, 0, NULL, 1, 0, 0, 'Поиск', '2010-03-19 00:00:00', 3);
INSERT INTO `elements` (`id`, `id_parent`, `id_type`, `id_obj`, `id_lang`, `id_tpl`, `id_menu`, `is_active`, `is_deleted`, `is_default`, `urlname`, `updatetime`, `ord`) VALUES(16, NULL, 39, 10015, 1, NULL, NULL, 1, 0, 0, 'shopsearch', '2011-06-30 11:03:45', 7);
INSERT INTO `elements` (`id`, `id_parent`, `id_type`, `id_obj`, `id_lang`, `id_tpl`, `id_menu`, `is_active`, `is_deleted`, `is_default`, `urlname`, `updatetime`, `ord`) VALUES(23, NULL, 24, 10026, 1, NULL, NULL, 1, 0, 0, 'sitemap', '2010-11-08 16:55:16', 2);
INSERT INTO `elements` (`id`, `id_parent`, `id_type`, `id_obj`, `id_lang`, `id_tpl`, `id_menu`, `is_active`, `is_deleted`, `is_default`, `urlname`, `updatetime`, `ord`) VALUES(34, NULL, 47, 10041, 1, NULL, 1000, 1, 0, 0, 'Регистрация', '2011-05-17 11:18:40', 9);
INSERT INTO `elements` (`id`, `id_parent`, `id_type`, `id_obj`, `id_lang`, `id_tpl`, `id_menu`, `is_active`, `is_deleted`, `is_default`, `urlname`, `updatetime`, `ord`) VALUES(35, NULL, 50, 10049, 1, NULL, 1000, 1, 0, 0, 'Profile', '2010-12-29 11:27:20', 2);
INSERT INTO `elements` (`id`, `id_parent`, `id_type`, `id_obj`, `id_lang`, `id_tpl`, `id_menu`, `is_active`, `is_deleted`, `is_default`, `urlname`, `updatetime`, `ord`) VALUES(43, NULL, 54, 10058, 1, NULL, NULL, 1, 0, 0, 'shopcart', '2011-05-12 16:45:54', 12);

-- --------------------------------------------------------

--
-- Структура таблицы `element_types`
--

CREATE TABLE IF NOT EXISTS `element_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `module` varchar(45) CHARACTER SET utf8 NOT NULL,
  `controller` varchar(45) CHARACTER SET utf8 NOT NULL,
  `action` varchar(45) CHARACTER SET utf8 NOT NULL DEFAULT 'view',
  `title` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `is_public` tinyint(1) NOT NULL DEFAULT '0',
  `is_child` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`module`,`controller`,`action`),
  KEY `id_public` (`is_public`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=107 ;

--
-- Дамп данных таблицы `element_types`
--

INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(1, 'admin', '', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(2, 'admin', 'auth', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(3, 'admin', 'module', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(4, 'admin', 'config', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(5, 'users', 'back', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(6, 'users', 'group', 'view', 'Группы пользователей', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(7, 'users', 'user', 'view', 'Пользователи', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(8, 'data', 'back', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(9, 'data', 'otype', 'view', 'Типы данных', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(10, 'data', 'group', 'view', 'Группы полей', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(11, 'data', 'field', 'view', 'Поля', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(12, 'menu', 'back', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(13, 'menu', '', 'view', 'Меню сайта', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(14, 'templates', 'back', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(15, 'templates', '', 'view', 'Шаблоны', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(16, 'content', 'back', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(17, 'content', '', 'view', 'Контент', 1, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(24, 'content', 'sitemap', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(25, 'trash', 'back', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(26, 'content', 'artic', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(29, 'system', 'back', 'view', 'Система', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(30, 'blocks', 'back', 'view', 'Блоки', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(31, 'search', '', 'view', '', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(32, 'search', 'back', 'view', 'Поиск', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(33, 'articles', 'back', 'view', NULL, 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(34, 'articles', 'category', 'view', 'Ленты статей', 1, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(35, 'articles', 'item', 'view', 'Статьи', 1, 1);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(36, 'catalog', 'back', 'view', NULL, 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(37, 'catalog', 'category', 'view', 'Категория каталога', 1, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(38, 'catalog', 'item', 'view', 'Элементы каталога', 1, 1);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(39, 'extsearch', '', 'view', 'Расширенный поиск', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(40, 'gallery', 'back', 'view', NULL, 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(41, 'gallery', 'category', 'view', 'Категории галереи', 1, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(42, 'gallery', 'item', 'view', 'Элементы галереи', 1, 1);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(46, 'users', '', 'view', 'Вход_выход', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(47, 'users', 'register', 'view', 'Регистрация', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(50, 'users', 'profile', 'view', 'Профиль пользователя', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(51, 'shop', 'item', 'view', 'Товар', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(52, 'shop', 'category', 'view', 'Категория товаров', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(53, 'shop', 'back', 'view', NULL, 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(54, 'shop', 'order', 'view', 'Заказ', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(55, 'shop', 'orders', 'view', NULL, 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(56, 'guides', 'back', 'view', 'Справочники', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(87, 'feedback', 'back', 'view', NULL, 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(88, 'feedback', '', 'view', 'Обратная связь', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(90, 'offers', 'back', 'view', NULL, 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(91, 'offers', 'category', 'view', 'Ленты акций', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(92, 'offers', 'item', 'view', 'Акции', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(93, 'news', 'back', 'view', NULL, 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(94, 'news', 'category', 'view', 'Ленты новостей', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(95, 'news', 'item', 'view', 'Новости', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(99, 'bulletin', 'back', 'view', NULL, 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(100, 'bulletin', 'category', 'view', 'Лента объявлений', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(101, 'bulletin', 'item', 'view', 'Элементы Объявлений', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(102, 'faq', 'back', 'view', NULL, 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(103, 'faq', 'category', 'view', 'Ленты ЧаВо', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(104, 'faq', 'item', 'view', 'ЧаВо', 0, 0);
INSERT INTO `element_types` (`id`, `module`, `controller`, `action`, `title`, `is_public`, `is_child`) VALUES(106, 'shop', 'robox', 'view', NULL, 1, 0);

-- --------------------------------------------------------

--
-- Структура таблицы `fields`
--

CREATE TABLE IF NOT EXISTS `fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 NOT NULL,
  `id_type` int(10) unsigned NOT NULL,
  `id_guide` int(10) unsigned DEFAULT NULL,
  `is_locked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_inheritable` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_public` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `is_required` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `tip` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `is_locked` (`is_locked`),
  KEY `is_inheritable` (`is_inheritable`),
  KEY `is_public` (`is_public`),
  KEY `is_required` (`is_required`),
  KEY `fk_fields_guide` (`id_guide`),
  KEY `fk_fields_field_types` (`id_type`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=221 ;

--
-- Дамп данных таблицы `fields`
--

INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(1, 'name', 100, 0, 1, 0, 1, 1, 'Название страницы', 'Короткое название страницы. Отображается в меню и в заголовке содержимого страницы');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(9, 'user_groupname', 100, 0, 1, 0, 1, 1, 'Название', 'Короткое название группы');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(10, 'user_name', 100, 0, 1, 0, 1, 1, 'Имя', 'Короткое название пользователя');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(11, 'login', 109, 0, 1, 0, 1, 1, 'Логин', 'Логин пользователя');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(12, 'user_group', 110, 1, 1, 0, 1, 1, 'Группа', 'Группа пользователей, к которой принадлежит пользователь');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(13, 'user_password', 111, 0, 1, 0, 1, 1, 'Пароль', 'Здесь можно сменить пароль пользователя');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(14, 'user_active', 105, 0, 1, 0, 1, 0, 'Активирован', 'Активировать или блокировать пользователя');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(20, 'menu_name', 100, 0, 1, 0, 1, 1, 'Название блока меню', 'Короткое название меню');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(21, 'menu_rooturl', 4, 0, 1, 0, 1, 0, 'Ссылка', 'URL корневого элемента для навигации');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(22, 'menu_class', 4, 0, 1, 0, 1, 0, 'Название класса CSS', 'Класс CSS для стилизации вывода меню');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(102, 'text', 12, 0, 1, 0, 1, 0, 'Редактирование содержимого страницы', 'Используется для редактирования содержимого страницы');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(103, 'urlname', 101, 0, 1, 0, 1, 1, 'Адрес страницы', 'Адрес страницы отображаемый в браузерной строке');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(104, 'title', 4, 0, 1, 0, 1, 0, 'Заголовок (Title)', 'Текст отображаемый в Мета-тегах TITLE страницы');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(105, 'title_text', 4, 0, 1, 0, 1, 0, 'Заголовок страницы', 'Текст отображаемый в тегах заголовка (H1-H6)');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(106, 'meta_keywords', 4, 0, 1, 0, 1, 0, 'Ключевые слова (Keywords)', 'Текст отображаемый в Мета-тегах KEYWORDS страницы');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(107, 'meta_description', 4, 0, 1, 0, 1, 0, 'Описание (Description)', 'Текст отображаемый в Мета-тегах DESCRIPTION страницы ');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(108, 'no_index', 1, 0, 1, 0, 0, 0, 'Индексация поисковиками', 'Запретить индексацию поисковиками');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(109, 'menu_sel', 104, 10, 1, 1, 1, 0, 'Выбрать меню', 'Выбирите в каком меню должна отображаться эта страница');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(110, 'menu_showsub', 1, 0, 1, 0, 1, 0, 'Показывать подменю', 'Управление отображением подменю');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(111, 'menu_collapsed', 1, 0, 1, 0, 1, 0, 'Свернуть подменю', 'Управление отображением подменю');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(112, 'menu_img_title', 10, 0, 1, 0, 1, 0, 'Изображение заголовка', 'Изображение для заголовка');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(113, 'menu_img_unactive', 10, 0, 1, 0, 1, 0, 'Изображение неактивного элемента', 'Изображение для неактивного элемента меню');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(114, 'menu_img_active', 10, 0, 1, 0, 1, 0, 'Изображение активного элемента', 'Изображение для активного элемента меню');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(115, 'datatype', 102, 0, 1, 0, 1, 1, 'Тип данных', 'Используемый тип данных');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(116, 'template', 103, 0, 1, 0, 1, 1, 'Шаблон', 'Используемый шаблон страницы');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(117, 'publish', 105, 0, 1, 0, 1, 0, 'Опубликовать/скрыть', 'Для того чтобы скрыть страницу на сайте уберите отметку');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(118, 'publish_date_to', 11, 0, 1, 0, 1, 0, 'До', 'Дата снятия с публикации');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(119, 'default', 106, 0, 1, 0, 1, 0, 'Главная', 'Для того чтобы сделать эту страницу главной поставьте отметку');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(120, 'description', 12, 0, 1, 0, 1, 0, 'Описание', 'Текстовое описание');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(121, 'news_preview', 12, 0, 1, 0, 1, 0, 'Анонс', 'Анонс новости');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(122, 'news_maintext', 12, 0, 1, 0, 1, 0, 'Текст', 'Основной текст новости');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(123, 'publish_arch', 1, 0, 1, 0, 1, 0, 'Архив', 'Перевести в архив');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(124, 'publish_date_from', 11, 0, 1, 0, 1, 0, 'Дата публикации', 'Дата публикации');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(125, 'publish_date_arch', 11, 0, 1, 0, 0, 0, 'В архив', 'Дата перевода в архив');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(126, 'publish_src_text', 4, 0, 1, 0, 1, 0, 'Источник', 'Текст ссылки на источник');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(127, 'publish_src_link', 4, 0, 1, 0, 1, 0, 'URL источника', 'URL ссылки на источник');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(128, 'permissions_elements', 107, 1, 1, 0, 0, 0, 'Привилегии', 'Установите права доступа на эту страницу');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(129, 'permissions_modules', 108, 0, 1, 0, 0, 0, 'Права группы пользователей', 'Пользователи этой группы имеют нижеуказанные права');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(132, 'element_photo', 14, 0, 1, 0, 1, 0, 'Изображение', 'Основное изображение данного элемента');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(133, 'catalog_item_preview', 12, 0, 1, 0, 1, 0, 'Краткое описание', 'Краткое описание товара');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(134, 'catalog_item_maintext', 12, 0, 1, 0, 1, 0, 'Текст', 'Основной текст товара');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(135, 'catalog_item_price', 3, 0, 1, 0, 1, 0, 'Цена', 'Цена товара');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(138, 'catalog_view', 112, 0, 1, 0, 1, 1, 'Шаблон вида', 'Шаблон вида');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(139, 'articles_preview', 12, 0, 1, 0, 1, 0, 'Анонс', 'Анонс статьи');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(140, 'articles_maintext', 12, 0, 1, 0, 1, 0, 'Текст', 'Основной текст статьи');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(141, 'gallery_item_preview', 5, 0, 1, 0, 1, 0, 'Краткое описание', 'Краткое описание изображения');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(143, 'news_image', 14, NULL, 0, 0, 1, 0, 'Изображение', 'Изображение');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(148, 'user_surname', 4, NULL, 0, 0, 1, 0, 'Фамилия', 'Фамилия');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(149, 'user_email', 13, NULL, 0, 0, 1, 1, 'Email', 'Email пользователя');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(150, 'shop_item_price', 3, NULL, 0, 0, 1, 0, 'Цена товара', 'Цена за единицу товара');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(151, 'shop_item_name', 4, NULL, 0, 0, 1, 1, 'Наименование', 'Название товара');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(152, 'shop_item_image', 14, NULL, 0, 0, 1, 0, 'Изображение', 'Картинка');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(153, 'shop_item_about', 12, NULL, 0, 0, 1, 0, 'Полное описание', 'Полное описание товара');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(154, 'user_address', 5, NULL, 0, 0, 1, 0, 'Адрес', 'Адрес доставки');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(155, 'shop_order_userid', 2, 2, 0, 0, 1, 1, 'Пользователь', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(156, 'shop_order_number', 2, NULL, 0, 0, 1, 1, '№ заказа', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(157, 'shop_order_sum', 3, NULL, 0, 0, 1, 1, 'Сумма заказа', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(158, 'shop_order_delivery', 6, 32, 0, 0, 1, 0, 'Способ доставки', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(159, 'shop_order_itemid', 2, 29, 0, 0, 1, 0, 'id товара', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(160, 'shop_order_item_price', 3, NULL, 0, 0, 1, 0, 'Цена товара', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(161, 'shop_order_item_count', 2, NULL, 0, 0, 1, 0, 'Количество', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(164, 'city_name', 113, NULL, 0, 0, 1, 1, 'Название города', 'В это поле вы должны вписать название города');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(165, '12112312423432', 4, NULL, 0, 0, 1, 0, 'фыв', '1');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(166, 'asd', 4, NULL, 0, 0, 1, 0, 'sdas', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(167, '123123', 113, NULL, 0, 0, 1, 0, 'Название', 'Пример &quot;Самовывоз:100&quot;');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(168, 'user_phone', 4, NULL, 0, 0, 1, 0, 'Телефон', 'Номер телефона');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(169, 'user_state', 6, 36, 0, 0, 1, 0, 'Город', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(170, 'shop_order_city', 6, 36, 0, 0, 1, 1, 'Город доставки', 'Город, в который требуется произвести доставку');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(171, 'shop_order_address', 4, NULL, 0, 0, 1, 1, 'Адрес доставки', 'Подробный адрес');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(172, 'shop_order_comment', 5, NULL, 0, 0, 1, 0, 'Комментарий к заказу', 'Комментарий');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(173, 'shop_order_payment', 6, 55, 0, 0, 1, 0, 'Способ оплаты', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(176, 'shop_order_date', 4, NULL, 0, 0, 1, 1, 'Дата заказа', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(177, 'shop_order_phone', 4, NULL, 0, 0, 1, 0, 'Контактный телефон', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(181, 'feedback_fos_type', 102, NULL, 0, 0, 1, 0, 'Тип формы', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(182, 'feedback_fos_captcha', 1, NULL, 0, 0, 1, 0, 'Капча', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(183, 'title_m', 4, NULL, 0, 0, 1, 0, 'Название отдела', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(184, 'mails_address', 4, NULL, 0, 0, 1, 0, 'E-mail', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(185, 'feedback_fos_mails', 7, 58, 0, 0, 1, 0, 'Список адресов', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(186, 'recip_name', 113, NULL, 0, 0, 1, 1, 'Адресат', 'Название отдела/адресата');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(187, 'recip_mail', 4, NULL, 0, 0, 1, 1, 'E-mail', 'E-mail адрес получателя');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(193, 'fb_fos_1', 4, NULL, 0, 0, 1, 1, 'Имя', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(194, 'fb_fos_2', 13, NULL, 0, 0, 1, 1, 'E-mail', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(195, 'fb_fos_3', 4, NULL, 0, 0, 1, 0, 'Телефон', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(196, 'fb_fos_4', 5, NULL, 0, 0, 1, 1, 'Сообщение', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(197, '123123123', 4, NULL, 0, 0, 1, 0, '123123123', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(198, 'shop_paymenttype', 113, NULL, 0, 0, 1, 0, 'Название', 'Например, webmoney');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(199, 'shop_order_delivery_price', 2, NULL, 0, 0, 1, 0, 'Цена', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(200, 'shop_item_shortabout', 12, NULL, 0, 0, 1, 0, 'Краткое описание', 'Краткое описание товара');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(201, 'shop_item_articul', 4, NULL, 0, 0, 1, 0, 'Артикул', 'Артикул товара');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(204, 'offers_link', 4, 0, 0, 0, 1, 0, 'Ссылка на товар', 'Скопируйте ссылку из адресной строки браузера');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(205, 'offers_item_preview', 12, NULL, 0, 0, 1, 0, 'Краткое описание', 'Краткое описание акции');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(206, 'offers_item_maintext', 12, NULL, 0, 0, 1, 0, 'Текст', 'Полное описание акции');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(209, 'bulletin_name', 4, NULL, 1, 0, 1, 1, 'Имя', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(210, 'bulletin_email', 13, NULL, 1, 0, 1, 0, 'E-mail', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(211, 'bulletin_phone', 4, NULL, 1, 0, 1, 0, 'Телефон', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(212, 'bulletin_maintext', 5, NULL, 1, 0, 1, 0, 'Объявление', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(213, 'faq_name', 4, NULL, 1, 0, 1, 0, 'Имя', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(214, 'faq_email', 13, NULL, 1, 0, 1, 0, 'E-mail', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(215, 'faq_question', 12, NULL, 1, 0, 1, 0, 'Вопрос', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(216, 'faq_answer', 12, NULL, 1, 0, 1, 0, 'Ответ', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(217, 'shop_order_payed', 6, 108, 0, 0, 1, 0, 'Оплата', NULL);
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(218, 'paystatus_name', 113, NULL, 0, 0, 1, 0, 'Название статуса', 'Например, оплачен');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(219, 'shop_order_status', 6, 109, 0, 0, 1, 0, 'Статус', 'status');
INSERT INTO `fields` (`id`, `name`, `id_type`, `id_guide`, `is_locked`, `is_inheritable`, `is_public`, `is_required`, `title`, `tip`) VALUES(220, 'order_status_title', 113, NULL, 0, 0, 1, 0, 'Статус', 'Например, отгружен');

-- --------------------------------------------------------

--
-- Структура таблицы `fields_controller`
--

CREATE TABLE IF NOT EXISTS `fields_controller` (
  `id_field` int(10) unsigned NOT NULL,
  `id_group` int(10) unsigned NOT NULL,
  `ord` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_group`,`id_field`),
  KEY `fk_fields_controller_fields` (`id_field`),
  KEY `fk_filelds_controller_field_groups` (`id_group`),
  KEY `ord` (`ord`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `fields_controller`
--

INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(9, 1, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(14, 2, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(20, 3, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(22, 3, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(111, 3, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 101, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 102, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 103, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 104, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 105, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 111, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 112, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 113, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 114, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 115, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 116, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 117, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 118, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 147, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 148, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 149, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 150, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 151, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 152, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 153, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 154, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 155, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(132, 156, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 157, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 158, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 159, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 160, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 161, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(132, 162, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 163, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 164, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 165, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 166, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 167, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 168, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 169, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(132, 170, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 171, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 172, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 173, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 174, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 175, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(132, 176, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 177, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 178, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 179, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 193, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 197, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 201, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 202, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(150, 203, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(152, 203, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(153, 203, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(200, 203, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(201, 203, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 204, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 205, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 206, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 207, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 208, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(155, 209, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(159, 210, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(160, 210, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(161, 210, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(164, 211, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(165, 211, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(167, 223, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(199, 223, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(198, 226, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(186, 229, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(187, 229, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 407, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 408, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 409, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 410, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 411, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(181, 412, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 421, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 422, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 423, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 424, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 425, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(181, 426, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(193, 427, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 428, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 429, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 430, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 431, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 432, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(181, 433, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 434, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 435, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 436, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 437, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 438, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 439, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(132, 440, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 441, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 442, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 443, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 444, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 445, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 446, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 447, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 448, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 449, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 450, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 451, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 452, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 453, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 454, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 455, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 456, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 457, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 458, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 459, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 460, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 461, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 462, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 463, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 464, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 465, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 466, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 467, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 468, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 469, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 470, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 471, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(181, 472, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 473, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(1, 475, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 476, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 477, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(115, 478, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(181, 479, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 480, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(218, 483, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(220, 484, 1);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(129, 1, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(10, 2, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(102, 101, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 102, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 104, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(102, 111, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 112, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 114, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(102, 116, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 117, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 118, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(120, 147, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 148, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 150, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(139, 152, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 153, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 154, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(120, 155, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 157, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 159, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(135, 161, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 163, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 164, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(120, 165, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 166, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 167, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(120, 169, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 171, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 173, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(141, 175, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 177, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 179, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 192, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 193, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 197, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 199, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 202, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 204, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 205, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 206, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 207, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 208, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(157, 209, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(158, 209, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(170, 209, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(171, 209, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(172, 209, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(173, 209, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(176, 209, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(177, 209, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(217, 209, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(219, 209, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(102, 407, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 408, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 410, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(182, 412, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(185, 412, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(102, 421, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 422, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 424, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(182, 426, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(185, 426, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(194, 427, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(195, 427, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(196, 427, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(102, 428, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 429, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 431, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(182, 433, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(185, 433, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(120, 434, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 435, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 437, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(204, 439, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 441, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 442, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(120, 443, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 444, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 446, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(121, 448, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 449, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 450, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(120, 452, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 453, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 455, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(209, 457, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 458, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 459, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(120, 460, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 461, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 463, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(213, 465, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 466, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 467, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(102, 468, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 469, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 471, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(182, 472, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(102, 475, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(103, 476, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(116, 478, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(182, 479, 2);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(11, 2, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 102, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 104, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 112, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 114, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 117, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 118, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 148, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 150, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(140, 152, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 153, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 154, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 157, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 159, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(133, 161, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 163, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 164, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 166, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 167, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 171, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 173, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 177, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 179, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 193, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(109, 195, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 197, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 202, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 204, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 205, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 206, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 207, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(104, 208, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 408, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 410, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 422, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 424, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 429, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 431, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 435, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 437, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(205, 439, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 441, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 442, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 444, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 446, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(122, 448, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 449, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 450, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 453, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 455, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(210, 457, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 458, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 459, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 461, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 463, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(214, 465, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 466, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 467, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 469, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 471, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(185, 472, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(106, 476, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(117, 478, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(185, 479, 3);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(13, 2, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(148, 2, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(149, 2, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(154, 2, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(168, 2, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(169, 2, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 102, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 104, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 112, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 114, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 117, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 118, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 148, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 150, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 153, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 157, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 159, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(134, 161, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 163, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 166, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 167, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 171, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 173, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 177, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 193, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 197, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 202, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 204, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 205, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 206, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 207, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 208, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 408, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 410, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 422, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 424, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 429, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 431, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 435, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 437, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(206, 439, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 441, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 444, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 446, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 449, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(123, 450, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 453, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 455, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(211, 457, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 458, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(124, 459, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 461, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 463, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(215, 465, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 466, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 469, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 471, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(105, 476, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(119, 478, 4);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 102, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 112, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 117, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(128, 119, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 148, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 153, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(124, 154, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 157, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(138, 159, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 163, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 166, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(138, 167, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 171, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(138, 173, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 177, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(102, 193, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(102, 208, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 408, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 422, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 429, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 435, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 441, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(124, 442, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 444, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 449, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(124, 450, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 453, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(212, 457, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 458, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 461, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(216, 465, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 466, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(124, 467, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 469, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(107, 476, 5);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(126, 154, 6);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(126, 450, 6);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(127, 154, 7);
INSERT INTO `fields_controller` (`id_field`, `id_group`, `ord`) VALUES(127, 450, 7);

-- --------------------------------------------------------

--
-- Структура таблицы `field_groups`
--

CREATE TABLE IF NOT EXISTS `field_groups` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=485 ;

--
-- Дамп данных таблицы `field_groups`
--

INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(1, 'usersgroup', 1, 1, 0, 1, 'Группа пользователей', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(2, 'user', 2, 1, 0, 1, 'Пользователь', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(3, 'menuset', 10, 1, 0, 1, 'Меню', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(101, 'common', 4, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(102, 'seo', 4, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(103, 'menu', 4, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(104, 'page', 4, 1, 0, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(105, 'permissions', 4, 1, 1, 0, 'Права доступа', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(111, 'common', 5, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(112, 'seo', 5, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(113, 'menu', 5, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(114, 'page', 5, 1, 0, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(115, 'permissions', 5, 1, 0, 0, 'Права доступа', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(116, 'common', 6, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(117, 'seo', 6, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(118, 'page', 6, 1, 0, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(119, 'permissions', 6, 1, 1, 0, 'Права доступа', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(147, 'common', 12, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(148, 'seo', 12, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(149, 'menu', 12, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(150, 'page', 12, 1, 1, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(151, 'permissions', 12, 1, 1, 0, 'Права доступа', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(152, 'common', 13, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(153, 'seo', 13, 1, 1, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(154, 'page', 13, 1, 1, 0, 'Настройки страницы', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(155, 'common', 14, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(156, 'photo', 14, 1, 0, 1, 'Редактирование фотографий', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(157, 'seo', 14, 1, 0, 0, 'Настройки для поисковых систем', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(158, 'menu', 14, 1, 0, 0, 'Настройки меню', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(159, 'page', 14, 1, 1, 0, 'Настройки страницы', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(160, 'permissions', 14, 1, 1, 0, 'Права доступа', 6);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(161, 'common', 15, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(162, 'photo', 15, 1, 0, 1, 'Редактирование фотографий', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(163, 'seo', 15, 1, 1, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(164, 'page', 15, 1, 1, 0, 'Настройки страницы', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(165, 'common', 16, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(166, 'seo', 16, 1, 0, 0, 'Настройки для поисковых систем', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(167, 'page', 16, 1, 1, 0, 'Настройки страницы', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(168, 'permissions', 16, 1, 1, 0, 'Права доступа', 6);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(169, 'common', 17, 1, 0, 1, 'Редактирование содержимого категории галереи', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(170, 'photo', 17, 1, 0, 0, 'Редактирование изображения', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(171, 'seo', 17, 1, 0, 0, 'Настройки для поисковых систем', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(172, 'menu', 17, 1, 0, 0, 'Настройки меню', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(173, 'page', 17, 1, 1, 0, 'Настройки страницы', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(174, 'permissions', 17, 1, 1, 0, 'Права доступа', 6);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(175, 'common', 18, 1, 0, 1, 'Редактирование содержимого элемента галереи', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(176, 'photo', 18, 1, 0, 0, 'Редактирование изображения', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(177, 'seo', 18, 1, 1, 0, 'Настройки для поисковых систем', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(178, 'menu', 18, 1, 0, 0, 'Настройки меню', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(179, 'page', 18, 1, 1, 0, 'Настройки страницы', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(192, 'permissions', 25, 1, 0, 0, 'Права доступа', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(193, 'common', 25, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(194, 'seo', 25, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(195, 'menu', 25, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(196, 'page', 25, 1, 0, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(197, 'common', 28, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(198, 'seo', 28, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(199, 'menu', 28, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(200, 'page', 28, 1, 0, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(201, 'permissions', 28, 1, 0, 1, 'Права доступа', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(202, 'page', 29, 1, 0, 1, 'Настройки страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(203, 'shop_item', 29, 1, 0, 1, 'Параметры товара', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(204, 'page', 30, 1, 0, 1, 'Свойства страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(205, 'common', 29, 1, 0, 1, 'Редактирование содержимого страницы	', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(206, 'common', 30, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(207, 'page', 31, 1, 0, 1, 'Настройки страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(208, 'common', 31, 1, 0, 1, 'Общие настройки', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(209, 'order_info', 34, 1, 0, 1, 'Информация о заказе', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(210, 'order_items', 35, 1, 0, 1, 'Содержимое заказа', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(211, 'cityes', 36, 1, 0, 1, 'Города', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(223, 'title', 32, 1, 0, 1, 'Название типа доставки', 0);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(226, '1554dcc532888d3eba43b50c06a5a7e9', 55, 1, 0, 1, 'FieldGroup1554dcc532888d3eba43b50c06a5a7e9', 0);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(229, 'c5f12fbae27e8b8faec9248421dd0792', 58, 1, 0, 1, 'FieldGroupc5f12fbae27e8b8faec9248421dd0792', 0);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(407, 'common', 92, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(408, 'seo', 92, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(409, 'menu', 92, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(410, 'page', 92, 1, 1, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(411, 'permissions', 92, 1, 1, 0, 'Права доступа', 6);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(412, 'feedback', 92, 1, 0, 0, 'Настройки формы обратной связи', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(421, 'common', 95, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(422, 'seo', 95, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(423, 'menu', 95, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(424, 'page', 95, 1, 1, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(425, 'permissions', 95, 1, 1, 0, 'Права доступа', 6);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(426, 'feedback', 95, 1, 0, 0, 'Настройки формы обратной связи', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(427, 'fos_fb_form', 96, 1, 0, 1, 'FieldGroupFOS', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(428, 'common', 96, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(429, 'seo', 96, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(430, 'menu', 96, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(431, 'page', 96, 1, 1, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(432, 'permissions', 96, 1, 1, 0, 'Права доступа', 6);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(433, 'feedback', 96, 1, 0, 0, 'Настройки формы обратной связи', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(434, 'common', 97, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(435, 'seo', 97, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(436, 'menu', 97, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(437, 'page', 97, 1, 1, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(438, 'permissions', 97, 1, 1, 0, 'Права доступа', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(439, 'common', 98, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(440, 'photo', 98, 1, 1, 0, 'Редактирование изображений', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(441, 'seo', 98, 1, 1, 0, 'Настройки для поисковых систем', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(442, 'page', 98, 1, 1, 0, 'Настройки страницы', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(443, 'common', 99, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(444, 'seo', 99, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(445, 'menu', 99, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(446, 'page', 99, 1, 1, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(447, 'permissions', 99, 1, 1, 0, 'Права доступа', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(448, 'common', 100, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(449, 'seo', 100, 1, 1, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(450, 'page', 100, 1, 1, 0, 'Настройки страницы', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(451, 'menu', 30, 1, 0, 1, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(452, 'common', 101, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(453, 'seo', 101, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(454, 'menu', 101, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(455, 'page', 101, 1, 1, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(456, 'permissions', 101, 1, 1, 0, 'Права доступа', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(457, 'common', 102, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(458, 'seo', 102, 1, 1, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(459, 'page', 102, 1, 1, 1, 'Настройки страницы', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(460, 'common', 103, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(461, 'seo', 103, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(462, 'menu', 103, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(463, 'page', 103, 1, 1, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(464, 'permissions', 103, 1, 1, 0, 'Права доступа', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(465, 'common', 104, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(466, 'seo', 104, 1, 1, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(467, 'page', 104, 1, 1, 0, 'Настройки страницы', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(468, 'common', 105, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(469, 'seo', 105, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(470, 'menu', 105, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(471, 'page', 105, 1, 0, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(472, 'feedback', 105, 1, 0, 0, 'Настройки формы обратной связи', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(473, 'permissions', 105, 1, 0, 0, 'Права доступа', 6);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(474, 'f90e373bb92892d7f23cf5a2eaf269af', 105, 1, 0, 1, 'FieldGroupf90e373bb92892d7f23cf5a2eaf269af', 0);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(475, 'common', 106, 1, 0, 1, 'Редактирование содержимого страницы', 1);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(476, 'seo', 106, 1, 0, 0, 'Настройки для поисковых систем', 2);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(477, 'menu', 106, 1, 0, 0, 'Настройки меню', 3);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(478, 'page', 106, 1, 0, 0, 'Настройки страницы', 4);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(479, 'feedback', 106, 1, 0, 0, 'Настройки формы обратной связи', 5);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(480, 'permissions', 106, 1, 0, 0, 'Права доступа', 6);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(481, 'b9360c408c7f110b8ac1f08635091726', 106, 1, 0, 1, 'FieldGroupb9360c408c7f110b8ac1f08635091726', 0);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(482, '6193fb25530390985c5753b5ffb62529', 107, 1, 0, 1, 'FieldGroup6193fb25530390985c5753b5ffb62529', 0);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(483, '4d93048952c0101a1249a92b8f4d3d38', 108, 1, 0, 1, 'FieldGroup4d93048952c0101a1249a92b8f4d3d38', 0);
INSERT INTO `field_groups` (`id`, `name`, `id_obj_type`, `is_active`, `is_locked`, `is_visible`, `title`, `ord`) VALUES(484, '507951d44335f816a978c3630dcb8104', 109, 1, 0, 1, 'FieldGroup507951d44335f816a978c3630dcb8104', 0);

-- --------------------------------------------------------

--
-- Структура таблицы `field_types`
--

CREATE TABLE IF NOT EXISTS `field_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `is_virtual` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `title` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `is_virtual` (`is_virtual`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=114 ;

--
-- Дамп данных таблицы `field_types`
--

INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(1, 'Boolean', 0, 'Флаг');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(2, 'Integer', 0, 'Целое');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(3, 'Float', 0, 'Число с точкой');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(4, 'String', 0, 'Строка');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(5, 'Text', 0, 'Текст');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(6, 'Select', 0, 'Список');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(7, 'MultiSelect', 0, 'Список с множественным выбором');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(8, 'MultiCheckbox', 0, 'Группа флагов');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(9, 'Radio', 0, 'Переключатель');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(10, 'File', 0, 'Файл');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(11, 'Date', 0, 'Дата');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(12, 'HtmlText', 0, 'Текстовое поле с визуальным редактором');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(13, 'Email', 0, 'Адрес электронной почты');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(14, 'Photo', 0, 'Фотография');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(100, 'Name', 1, 'Название');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(101, 'Urlname', 1, 'Псевдостатический адрес');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(102, 'ObjType', 1, 'Тип данных');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(103, 'Template', 1, 'Шаблон');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(104, 'Menu', 1, 'Меню');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(105, 'Active', 1, 'Активность');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(106, 'DefaultPage', 1, 'Страница по-умолчанию');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(107, 'ElementPermissions', 1, 'Права доступа на элемент');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(108, 'ModulePermissions', 1, 'Права доступа на модуль');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(109, 'UserLogin', 1, 'Логин пользователя');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(110, 'UserGroup', 1, 'Группа пользователей');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(111, 'UserPassword', 1, 'Пароль пользователя');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(112, 'TemplateView', 0, 'Шаблон вида');
INSERT INTO `field_types` (`id`, `name`, `is_virtual`, `title`) VALUES(113, 'GuideTitle', 1, 'Название элемента справочника');

-- --------------------------------------------------------

--
-- Структура таблицы `languages`
--

CREATE TABLE IF NOT EXISTS `languages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `is_default` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `prefix` varchar(16) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `prefix` (`prefix`),
  KEY `title` (`title`),
  KEY `is_default` (`is_default`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=3 ;

--
-- Дамп данных таблицы `languages`
--

INSERT INTO `languages` (`id`, `is_default`, `prefix`, `title`) VALUES(1, 1, 'ru', 'Русский');
INSERT INTO `languages` (`id`, `is_default`, `prefix`, `title`) VALUES(2, 0, 'en', 'English');

-- --------------------------------------------------------

--
-- Структура таблицы `objects`
--

CREATE TABLE IF NOT EXISTS `objects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_type` int(10) unsigned NOT NULL,
  `is_locked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_objects_object_types` (`id_type`),
  KEY `name` (`title`),
  KEY `is_locked` (`is_locked`)
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=10388 ;

--
-- Дамп данных таблицы `objects`
--

INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(1, 1, 1, 'Посетители');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(2, 1, 1, 'Зарегестрированные пользователи');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(3, 1, 1, 'Служба поддержки');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(4, 1, 1, 'Администраторы сайта');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(5, 2, 1, 'Витя');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(6, 2, 0, 'Владелец сайта');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(1000, 10, 0, 'Главное меню');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10000, 5, 0, 'Главная');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10001, 6, 0, 'Результаты поиска');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10015, 16, 0, 'Расширенный поиск');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10025, 2, 0, 'admin');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10026, 21, 0, 'Карта_сайта');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10041, 25, 0, 'Регистрация');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10049, 28, 0, 'Профиль');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10058, 31, 0, 'Ваша корзина');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10061, 32, 0, 'Забрать самостоятельно');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10062, 32, 0, 'Доставка курьером');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10152, 32, 0, 'Доставка Почтой России');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10157, 32, 0, 'Передать в метро');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10204, 58, 0, 'all');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10220, 96, 0, 'ФОС');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10262, 101, 0, 'Объявления');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10268, 103, 0, 'Вопрос-Ответ');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10270, 5, 0, 'Демо');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10271, 55, 0, 'Электронные средства оплаты');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10272, 55, 0, 'Наличными курьеру');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10273, 55, 0, 'Банковский перевод');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10314, 108, 0, 'Оплачен');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10315, 108, 0, 'Не оплачен');
INSERT INTO `objects` (`id`, `id_type`, `is_locked`, `title`) VALUES(10381, 109, 0, 'Отгружен');

-- --------------------------------------------------------

--
-- Структура таблицы `object_types`
--

CREATE TABLE IF NOT EXISTS `object_types` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=110 ;

--
-- Дамп данных таблицы `object_types`
--

INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(1, 0, 6, 1, 0, 0, 'Группа пользователей');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(2, 0, 7, 0, 1, 0, 'Пользователь');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(4, 0, 0, 0, 0, 0, 'Раздел сайта');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(5, 4, 17, 0, 1, 1, 'Страницы');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(6, 0, 31, 0, 0, 1, 'Результаты поиска');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(10, 0, 13, 0, 0, 0, 'Меню сайта');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(12, 4, 34, 0, 1, 1, 'Лента статей');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(13, 4, 35, 0, 1, 1, 'Статья');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(14, 4, 37, 0, 1, 1, 'Категория каталога');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(15, 4, 38, 0, 1, 1, 'Элемент каталога');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(16, 4, 39, 0, 0, 1, 'Поиск по каталогу');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(17, 4, 41, 0, 1, 1, 'Категория галереи');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(18, 4, 42, 0, 1, 1, 'Элемент галереи');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(21, 4, 24, 0, 0, 1, 'Карта_сайта');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(25, 4, 47, 0, 0, 1, 'Страница регистрации');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(28, 4, 50, 0, 0, 1, 'Профиль пользователя');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(29, 4, 51, 0, 1, 1, 'Товар');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(30, 4, 52, 0, 1, 1, 'Категория товара');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(31, 4, 54, 0, 0, 1, 'Страница заказа');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(32, NULL, 56, 0, 1, 1, 'Способ доставки');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(34, NULL, 55, 0, 0, 1, 'Заказ');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(35, 34, 56, 0, 1, 1, 'Заказ инфо');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(36, NULL, 56, 0, 1, 1, 'Города');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(54, NULL, 56, 0, 1, 1, 'Справочничек');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(55, NULL, 56, 0, 1, 1, 'Способы оплаты');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(58, NULL, 56, 0, 1, 1, 'Список адресов');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(95, 4, 88, 0, 0, 0, 'Обратная связь');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(96, 95, 88, 0, 0, 0, 'ФОС');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(97, 4, 91, 0, 1, 1, 'Лента акции');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(98, 4, 92, 0, 1, 1, 'Акция');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(99, 4, 94, 0, 1, 1, 'Лента новостей');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(100, 4, 95, 0, 1, 1, 'Новость');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(101, 4, 100, 0, 1, 1, 'Лента объявления');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(102, 4, 101, 0, 1, 1, 'Элемент объявления');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(103, 4, 103, 0, 1, 1, 'Лента ЧаВо');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(104, 4, 104, 0, 1, 1, 'ЧаВо');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(106, 95, 0, 0, 0, 0, 'huih');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(108, NULL, 56, 0, 1, 1, 'Статусы оплаты');
INSERT INTO `object_types` (`id`, `id_parent`, `id_element_type`, `is_locked`, `is_guidable`, `is_public`, `title`) VALUES(109, NULL, 56, 0, 1, 0, 'Статусы заказа');

-- --------------------------------------------------------

--
-- Структура таблицы `permissions_elements`
--

CREATE TABLE IF NOT EXISTS `permissions_elements` (
  `id_owner` int(10) unsigned NOT NULL,
  `id_element` int(10) unsigned NOT NULL,
  `mode` varchar(45) NOT NULL,
  `allow` int(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_owner`,`id_element`,`mode`),
  KEY `fk_permissions_elements_elements` (`id_element`),
  KEY `fk_permissions_elements_usergroup` (`id_owner`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `permissions_elements`
--

INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(1, 17, 'view', 1);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(1, 35, 'edit', 0);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(1, 35, 'view', 0);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(2, 17, 'view', 1);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(2, 34, 'view', 0);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(2, 35, 'edit', 1);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(2, 35, 'view', 1);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(3, 34, 'view', 1);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(3, 35, '', 1);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(4, 2, 'edit', 0);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(4, 2, 'view', 0);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(4, 16, 'edit', 0);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(4, 16, 'view', 1);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(4, 17, 'view', 1);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(4, 34, 'view', 1);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(4, 35, '', 1);
INSERT INTO `permissions_elements` (`id_owner`, `id_element`, `mode`, `allow`) VALUES(10029, 35, 'view', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `permissions_modules`
--

CREATE TABLE IF NOT EXISTS `permissions_modules` (
  `id_owner` int(10) unsigned NOT NULL,
  `id_etype` int(10) unsigned NOT NULL,
  `mode` varchar(45) NOT NULL DEFAULT '',
  `allow` tinyint(1) unsigned DEFAULT NULL,
  PRIMARY KEY (`id_owner`,`id_etype`,`mode`),
  KEY `fk_permissions_modules_element_types` (`id_etype`),
  KEY `fk_permissions_modules_usergroup` (`id_owner`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `permissions_modules`
--

INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 1, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 2, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 3, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 7, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 13, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 17, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 24, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 26, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 31, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 34, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 35, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 37, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 38, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 39, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 41, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 42, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 46, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 47, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 50, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 51, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 52, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 54, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 54, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 56, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 88, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 91, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 92, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 94, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 95, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 100, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 101, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 101, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 103, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 104, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 104, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 106, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(1, 106, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(2, 55, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 1, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 3, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 4, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 5, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 6, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 7, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 8, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 9, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 10, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 11, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 12, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 13, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 14, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 15, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 16, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 17, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 24, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 25, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 26, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 29, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 30, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 31, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 32, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 33, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 34, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 35, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 36, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 37, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 38, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 39, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 40, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 41, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 42, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 46, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 47, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 47, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 50, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 50, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 51, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 51, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 52, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 52, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 53, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 53, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 53, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 54, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 54, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 55, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 56, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 56, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 56, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 87, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 88, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 90, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 91, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 91, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 92, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 92, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 93, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 94, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 94, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 95, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 95, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 99, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 100, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 100, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 101, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 101, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 102, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 103, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 103, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 104, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 104, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 106, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(3, 106, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 3, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 4, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 5, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 6, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 6, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 7, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 7, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 8, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 9, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 9, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 10, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 10, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 11, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 11, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 12, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 13, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 14, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 15, 'edit', 0);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 15, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 16, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 17, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 25, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 29, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 29, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 30, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 30, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 32, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 32, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 33, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 34, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 35, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 36, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 37, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 38, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 40, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 41, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 42, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 46, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 47, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 47, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 50, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 50, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 54, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 54, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 56, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 56, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 87, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 88, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 90, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 91, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 91, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 92, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 92, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 93, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 94, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 94, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 95, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 95, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 99, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 100, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 100, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 101, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 101, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 102, '', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 103, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 103, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 104, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 104, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 106, 'edit', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(4, 106, 'view', 1);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(10029, 3, '', 0);
INSERT INTO `permissions_modules` (`id_owner`, `id_etype`, `mode`, `allow`) VALUES(10029, 16, '', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `registry`
--

CREATE TABLE IF NOT EXISTS `registry` (
  `var` varchar(48) NOT NULL,
  `val` text CHARACTER SET utf8,
  PRIMARY KEY (`var`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

--
-- Дамп данных таблицы `registry`
--

INSERT INTO `registry` (`var`, `val`) VALUES('articles_items_count', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('artic_active', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('artic_title', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('buy_without_reg', '"1"');
INSERT INTO `registry` (`var`, `val`) VALUES('catalog_big_size', '"1024"');
INSERT INTO `registry` (`var`, `val`) VALUES('catalog_items_count', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('catalog_kategory_size', '"80"');
INSERT INTO `registry` (`var`, `val`) VALUES('catalog_medium_size', '"400"');
INSERT INTO `registry` (`var`, `val`) VALUES('catalog_small_size', '"170"');
INSERT INTO `registry` (`var`, `val`) VALUES('catalog_socbuttons', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('check_browser', '"1"');
INSERT INTO `registry` (`var`, `val`) VALUES('gallery_big_size', '"1024"');
INSERT INTO `registry` (`var`, `val`) VALUES('gallery_items_count', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('gallery_kategory_size', '"80"');
INSERT INTO `registry` (`var`, `val`) VALUES('gallery_medium_size', '"400"');
INSERT INTO `registry` (`var`, `val`) VALUES('gallery_small_size', '"170"');
INSERT INTO `registry` (`var`, `val`) VALUES('gallery_square_big', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('gallery_square_kategory', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('gallery_square_medium', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('gallery_square_small', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('modules_order', '["admin","data","menu","templates","users","trash"]');
INSERT INTO `registry` (`var`, `val`) VALUES('news_items_count', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('offers_big_size', '"1024"');
INSERT INTO `registry` (`var`, `val`) VALUES('offers_items_count', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('offers_medium_size', '"400"');
INSERT INTO `registry` (`var`, `val`) VALUES('offers_small_size', '"170"');
INSERT INTO `registry` (`var`, `val`) VALUES('offers_socbuttons', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('offers_square_big', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('offers_square_medium', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('offers_square_small', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('parse_content', '"1"');
INSERT INTO `registry` (`var`, `val`) VALUES('robots_text', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('search_active', '"1"');
INSERT INTO `registry` (`var`, `val`) VALUES('shop_email', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('shop_robox_delivid', '"10271"');
INSERT INTO `registry` (`var`, `val`) VALUES('shop_robox_login', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('shop_robox_passwd_1', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('shop_robox_passwd_2', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('shop_robox_test', '"1"');
INSERT INTO `registry` (`var`, `val`) VALUES('shop_socbuttons', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('site_description', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('site_keywords', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('site_name', '""');
INSERT INTO `registry` (`var`, `val`) VALUES('square_big_active', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('square_kategory_active', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('square_medium_active', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('square_small_active', '"0"');
INSERT INTO `registry` (`var`, `val`) VALUES('users_active_mode', '"1"');
INSERT INTO `registry` (`var`, `val`) VALUES('use_urlnames', '"1"');

-- --------------------------------------------------------

--
-- Структура таблицы `shop_orders`
--

CREATE TABLE IF NOT EXISTS `shop_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_obj` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=78 ;

-- --------------------------------------------------------

--
-- Структура таблицы `shop_order_info`
--

CREATE TABLE IF NOT EXISTS `shop_order_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_order` int(11) NOT NULL,
  `id_obj` int(11) NOT NULL,
  `id_element` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKshop_order131973` (`id_order`)
) ENGINE=MyISAM  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=64 ;

-- --------------------------------------------------------

--
-- Структура таблицы `templates`
--

CREATE TABLE IF NOT EXISTS `templates` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=4 ;

--
-- Дамп данных таблицы `templates`
--

INSERT INTO `templates` (`id`, `id_lang`, `is_default`, `filename`, `title`) VALUES(1, 1, 0, 'default', 'Базовый Шаблон');
INSERT INTO `templates` (`id`, `id_lang`, `is_default`, `filename`, `title`) VALUES(2, 1, 1, 'template', 'Основной Шаблон');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE IF NOT EXISTS `users` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=cp1251 AUTO_INCREMENT=52 ;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `name`, `id_object`, `id_usergroup`, `is_active`, `password`) VALUES(9, 'admin', 10025, 3, 1, '46705c3fe53844648091bc913a0893d8');

-- --------------------------------------------------------

--
-- Структура таблицы `views`
--

CREATE TABLE IF NOT EXISTS `views` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(100) COLLATE utf8_bin DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `id_etype` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_views_1` (`id_etype`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=8 ;

--
-- Дамп данных таблицы `views`
--

INSERT INTO `views` (`id`, `title`, `filename`, `id_etype`) VALUES(1, 'Содержимое страницы', 'view', 17);
INSERT INTO `views` (`id`, `title`, `filename`, `id_etype`) VALUES(2, 'Лента статей', 'category', 34);
INSERT INTO `views` (`id`, `title`, `filename`, `id_etype`) VALUES(3, 'Статья', 'item', 35);
INSERT INTO `views` (`id`, `title`, `filename`, `id_etype`) VALUES(4, 'Категория каталога', 'category', 37);
INSERT INTO `views` (`id`, `title`, `filename`, `id_etype`) VALUES(5, 'Элемент каталога', 'item', 38);
INSERT INTO `views` (`id`, `title`, `filename`, `id_etype`) VALUES(6, 'Категория галереи (lightbox)', 'lightbox', 41);
INSERT INTO `views` (`id`, `title`, `filename`, `id_etype`) VALUES(7, 'Категория галереи (galleria)', 'galleria', 41);


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

SET FOREIGN_KEY_CHECKS=1;
