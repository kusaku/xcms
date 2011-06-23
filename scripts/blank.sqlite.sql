-- $Id: blank.sqlite.sql 240 2010-07-13 10:15:55Z renat $

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

INSERT INTO objects VALUES (1,1,1,'Гости');
INSERT INTO objects VALUES (2,1,1,'Зарегестрированные пользователи');
INSERT INTO objects VALUES (3,1,1,'Служба поддержки'); -- Administrator
INSERT INTO objects VALUES (4,1,1,'Администраторы сайта'); -- Limited
INSERT INTO objects VALUES (5,2,1,'Специалист Фабрики сайтов');
INSERT INTO objects VALUES (6,2,0,'Владелец сайта');
INSERT INTO objects VALUES (1000,10,0,'Главное меню');
INSERT INTO objects VALUES (10000,5,0,'Главная');
INSERT INTO objects VALUES (10001,6,0,'Новости');
INSERT INTO objects VALUES (10002,11,0,'Контакты');

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

INSERT INTO elements VALUES(1,NULL,17,10000,1,NULL,1000,1,0,1,'Главная','2010-05-31',1);
INSERT INTO elements VALUES(2,NULL,19,10001,1,NULL,1000,1,0,0,'Новости','2010-05-31',2);
INSERT INTO elements VALUES(3,NULL,28,10002,1,NULL,1000,1,0,0,'Контакты','2010-06-23',3);


-- -----------------------------------------------------
-- Data for table content
-- (id_obj, id_field, val_int, val_float, val_varchar, val_text, val_rel_obj, val_rel_elem)
-- -----------------------------------------------------



-- -----------------------------------------------------
-- Data for table permissions_modules
-- -----------------------------------------------------

INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 2, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 17, 'view', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 19, 'view', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 20, 'view', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 22, 'view', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (1, 23, 'view', 1);
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
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 21, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 22, '', 1);
INSERT INTO permissions_modules (id_owner, id_etype, mode, allow) VALUES (3, 23, '', 1);
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

INSERT INTO registry (var, val) VALUES('site_name','s:0:"";');
INSERT INTO registry (var, val) VALUES('site_description','s:0:"";');
INSERT INTO registry (var, val) VALUES('site_keywords','s:0:"";');
INSERT INTO registry (var, val) VALUES('use_urlnames','s:1:"1";');
INSERT INTO registry (var, val) VALUES('modules_order','a:7:{i:0;s:5:"admin";i:1;s:4:"data";i:2;s:4:"menu";i:3;s:4:"news";i:4;s:9:"templates";i:5;s:5:"users";i:6;s:5:"trash";}');
INSERT INTO registry (var, val) VALUES('artic_active','s:1:"1";');


