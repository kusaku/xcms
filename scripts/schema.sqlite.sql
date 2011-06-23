-- Creator:       MySQL Workbench 5.1.18/ExportSQLite plugin 2009.12.02
-- Author:        Renat
-- Caption:       XCMS Data Model
-- Project:       XCMS
-- Changed:       2010-07-06 18:53
-- Created:       2009-09-15 13:16
PRAGMA foreign_keys = OFF;

-- Schema: xcms
BEGIN;
CREATE TABLE "element_types"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("id">=0),
  "module" VARCHAR(45) NOT NULL,
  "controller" VARCHAR(45) NOT NULL,
  "title" VARCHAR(255) DEFAULT NULL,
  CONSTRAINT "name"
    UNIQUE("module","controller")
);
CREATE TABLE "languages"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("id">=0),
  "is_default" INTEGER NOT NULL CHECK("is_default">=0) DEFAULT 0,
  "prefix" VARCHAR(16) NOT NULL,
  "title" VARCHAR(255) DEFAULT NULL
);
CREATE INDEX "languages.prefix" ON "languages"("prefix");
CREATE INDEX "languages.title" ON "languages"("title");
CREATE INDEX "languages.is_default" ON "languages"("is_default");
CREATE TABLE "field_types"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("id">=0),
  "name" VARCHAR(20) DEFAULT NULL,
  "is_virtual" INTEGER NOT NULL CHECK("is_virtual">=0) DEFAULT 0,
  "title" VARCHAR(64) DEFAULT NULL,
  CONSTRAINT "name"
    UNIQUE("name")
);
CREATE INDEX "field_types.is_virtual" ON "field_types"("is_virtual");
CREATE TABLE "object_types"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("id">=0),
  "id_parent" INTEGER CHECK("id_parent">=0) DEFAULT NULL,
  "id_element_type" INTEGER CHECK("id_element_type">=0) DEFAULT NULL,
  "is_locked" INTEGER NOT NULL CHECK("is_locked">=0) DEFAULT 0,
  "is_guidable" INTEGER NOT NULL CHECK("is_guidable">=0) DEFAULT 0,
  "is_public" INTEGER NOT NULL CHECK("is_public">=0) DEFAULT 1,
  "title" VARCHAR(255) NOT NULL,
  CONSTRAINT "fk_object_types_element_types"
    FOREIGN KEY("id_element_type")
    REFERENCES "element_types"("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT "fk_object_type_parent"
    FOREIGN KEY("id_parent")
    REFERENCES "object_types"("id")
);
CREATE INDEX "object_types.is_public" ON "object_types"("is_public");
CREATE INDEX "object_types.is_locked" ON "object_types"("is_locked");
CREATE INDEX "object_types.is_guidable" ON "object_types"("is_guidable");
CREATE TABLE "objects"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("id">=0),
  "id_type" INTEGER NOT NULL CHECK("id_type">=0),
  "is_locked" INTEGER NOT NULL CHECK("is_locked">=0) DEFAULT 0,
  "title" VARCHAR(255) NOT NULL,
  CONSTRAINT "fk_objects_object_types"
    FOREIGN KEY("id_type")
    REFERENCES "object_types"("id")
);
CREATE INDEX "objects.fk_objects_object_types" ON "objects"("id_type");
CREATE INDEX "objects.name" ON "objects"("title");
CREATE INDEX "objects.is_locked" ON "objects"("is_locked");
CREATE TABLE "templates"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("id">=0),
  "id_lang" INTEGER NOT NULL CHECK("id_lang">=0),
  "is_default" INTEGER NOT NULL CHECK("is_default">=0) DEFAULT 0,
  "filename" VARCHAR(64) DEFAULT NULL,
  "title" VARCHAR(255) DEFAULT NULL,
  CONSTRAINT "fk_templates_languages"
    FOREIGN KEY("id_lang")
    REFERENCES "languages"("id")
);
CREATE INDEX "templates.is_default" ON "templates"("is_default");
CREATE INDEX "templates.filename" ON "templates"("filename");
CREATE INDEX "templates.title" ON "templates"("title");
CREATE TABLE "permissions_modules"(
  "id_owner" INTEGER NOT NULL CHECK("id_owner">=0),
  "id_etype" INTEGER NOT NULL CHECK("id_etype">=0),
  "mode" VARCHAR(45) NOT NULL,
  "allow" INTEGER CHECK("allow">=0) DEFAULT NULL,
  PRIMARY KEY("id_owner","id_etype","mode"),
  CONSTRAINT "fk_permissions_modules_element_types"
    FOREIGN KEY("id_etype")
    REFERENCES "element_types"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT "fk_permissions_modules_usergroup"
    FOREIGN KEY("id_owner")
    REFERENCES "objects"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
CREATE TABLE "registry"(
  "var" VARCHAR(48) PRIMARY KEY NOT NULL,
  "val" VARCHAR(255) DEFAULT NULL
);
CREATE TABLE "users"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("id">=0),
  "name" VARCHAR(64) NOT NULL,
  "id_object" INTEGER NOT NULL CHECK("id_object">=0),
  "id_usergroup" INTEGER NOT NULL CHECK("id_usergroup">=0),
  "is_active" INTEGER NOT NULL CHECK("is_active">=0) DEFAULT 0,
  "password" VARCHAR(32),
  CONSTRAINT "name"
    UNIQUE("name"),
  CONSTRAINT "fk_users_objects"
    FOREIGN KEY("id_object")
    REFERENCES "objects"("id"),
  CONSTRAINT "fk_users_usergroup"
    FOREIGN KEY("id_usergroup")
    REFERENCES "objects"("id")
);
CREATE TABLE "elements"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("id">=0),
  "id_parent" INTEGER CHECK("id_parent">=0) DEFAULT NULL,
  "id_type" INTEGER NOT NULL CHECK("id_type">=0),
  "id_obj" INTEGER NOT NULL CHECK("id_obj">=0),
  "id_lang" INTEGER NOT NULL CHECK("id_lang">=0),
  "id_tpl" INTEGER CHECK("id_tpl">=0) DEFAULT NULL,
  "id_menu" INTEGER CHECK("id_menu">=0) DEFAULT NULL,
  "is_active" INTEGER NOT NULL CHECK("is_active">=0) DEFAULT 1,
  "is_deleted" INTEGER NOT NULL CHECK("is_deleted">=0) DEFAULT 0,
  "is_default" INTEGER NOT NULL CHECK("is_default">=0) DEFAULT 0,
  "urlname" VARCHAR(128) DEFAULT NULL,
  "updatetime" DATETIME DEFAULT NULL,
  "ord" INTEGER DEFAULT NULL,
  CONSTRAINT "urlname"
    UNIQUE("urlname"),
  CONSTRAINT "fk_elements_templates"
    FOREIGN KEY("id_tpl")
    REFERENCES "templates"("id"),
  CONSTRAINT "fk_elements_objects"
    FOREIGN KEY("id_obj")
    REFERENCES "objects"("id"),
  CONSTRAINT "fk_elements_languages"
    FOREIGN KEY("id_lang")
    REFERENCES "languages"("id"),
  CONSTRAINT "fk_elements_types"
    FOREIGN KEY("id_type")
    REFERENCES "element_types"("id"),
  CONSTRAINT "fk_element_parent"
    FOREIGN KEY("id_parent")
    REFERENCES "elements"("id"),
  CONSTRAINT "fk_element_menu"
    FOREIGN KEY("id_menu")
    REFERENCES "objects"("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
CREATE INDEX "elements.fk_elements_types" ON "elements"("id_type");
CREATE INDEX "elements.fk_elements_languages" ON "elements"("id_lang");
CREATE INDEX "elements.fk_elements_objects" ON "elements"("id_obj");
CREATE INDEX "elements.fk_elements_templates" ON "elements"("id_tpl");
CREATE INDEX "elements.is_default" ON "elements"("is_default");
CREATE INDEX "elements.is_deleted" ON "elements"("is_deleted");
CREATE INDEX "elements.is_active" ON "elements"("is_active");
CREATE INDEX "elements.ord" ON "elements"("ord");
CREATE INDEX "elements.updatetime" ON "elements"("updatetime");
CREATE TABLE "field_groups"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("id">=0),
  "name" VARCHAR(64) NOT NULL,
  "id_obj_type" INTEGER NOT NULL CHECK("id_obj_type">=0),
  "is_active" INTEGER NOT NULL CHECK("is_active">=0) DEFAULT 1,
  "is_locked" INTEGER NOT NULL CHECK("is_locked">=0) DEFAULT 0,
  "is_visible" INTEGER NOT NULL CHECK("is_visible">=0) DEFAULT 1,
  "title" VARCHAR(255) DEFAULT NULL,
  "ord" INTEGER DEFAULT NULL,
  CONSTRAINT "fk_field_groups_object_types"
    FOREIGN KEY("id_obj_type")
    REFERENCES "object_types"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
CREATE INDEX "field_groups.ord" ON "field_groups"("ord");
CREATE INDEX "field_groups.name" ON "field_groups"("name");
CREATE INDEX "field_groups.is_active" ON "field_groups"("is_active");
CREATE INDEX "field_groups.is_visible" ON "field_groups"("is_visible");
CREATE INDEX "field_groups.is_locked" ON "field_groups"("is_locked");
CREATE INDEX "field_groups.fk_field_groups_object_types" ON "field_groups"("id_obj_type");
CREATE TABLE "fields"(
  "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL CHECK("id">=0),
  "name" VARCHAR(64) NOT NULL,
  "id_type" INTEGER NOT NULL CHECK("id_type">=0),
  "id_guide" INTEGER CHECK("id_guide">=0) DEFAULT NULL,
  "is_locked" INTEGER NOT NULL CHECK("is_locked">=0) DEFAULT 0,
  "is_inheritable" INTEGER NOT NULL CHECK("is_inheritable">=0) DEFAULT 0,
  "is_public" INTEGER NOT NULL CHECK("is_public">=0) DEFAULT 1,
  "is_required" INTEGER NOT NULL CHECK("is_required">=0) DEFAULT 0,
  "title" VARCHAR(255) DEFAULT NULL,
  "tip" VARCHAR(255) DEFAULT NULL,
  CONSTRAINT "name"
    UNIQUE("name"),
  CONSTRAINT "fk_fields_field_types"
    FOREIGN KEY("id_type")
    REFERENCES "field_types"("id"),
  CONSTRAINT "fk_fields_guide"
    FOREIGN KEY("id_guide")
    REFERENCES "object_types"("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
CREATE INDEX "fields.is_locked" ON "fields"("is_locked");
CREATE INDEX "fields.is_inheritable" ON "fields"("is_inheritable");
CREATE INDEX "fields.is_public" ON "fields"("is_public");
CREATE INDEX "fields.is_required" ON "fields"("is_required");
CREATE TABLE "permissions_elements"(
  "id_owner" INTEGER NOT NULL CHECK("id_owner">=0),
  "id_element" INTEGER NOT NULL CHECK("id_element">=0),
  "mode" VARCHAR(45) NOT NULL,
  "allow" INTEGER CHECK("allow">=0) DEFAULT NULL,
  PRIMARY KEY("id_owner","id_element","mode"),
  CONSTRAINT "fk_permissions_elements_elements"
    FOREIGN KEY("id_element")
    REFERENCES "elements"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT "fk_permissions_elements_usergroup"
    FOREIGN KEY("id_owner")
    REFERENCES "objects"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
CREATE TABLE "fields_controller"(
  "id_field" INTEGER NOT NULL CHECK("id_field">=0),
  "id_group" INTEGER NOT NULL CHECK("id_group">=0),
  "ord" INTEGER DEFAULT NULL,
  PRIMARY KEY("id_group","id_field"),
  CONSTRAINT "fk_fields_controller_fields"
    FOREIGN KEY("id_field")
    REFERENCES "fields"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT "fk_filelds_controller_field_groups"
    FOREIGN KEY("id_group")
    REFERENCES "field_groups"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
CREATE INDEX "fields_controller.fk_fields_controller_fields" ON "fields_controller"("id_field");
CREATE INDEX "fields_controller.fk_filelds_controller_field_groups" ON "fields_controller"("id_group");
CREATE INDEX "fields_controller.ord" ON "fields_controller"("ord");
CREATE TABLE "content"(
  "id_obj" INTEGER NOT NULL CHECK("id_obj">=0),
  "id_field" INTEGER NOT NULL CHECK("id_field">=0),
  "val_int" INTEGER DEFAULT NULL,
  "val_float" FLOAT DEFAULT NULL,
  "val_varchar" VARCHAR(255) DEFAULT NULL,
  "val_text" MEDIUMTEXT DEFAULT NULL,
  "val_rel_obj" INTEGER CHECK("val_rel_obj">=0) DEFAULT NULL,
  "val_rel_elem" INTEGER CHECK("val_rel_elem">=0) DEFAULT NULL,
  PRIMARY KEY("id_obj","id_field"),
  CONSTRAINT "fk_content_objects"
    FOREIGN KEY("id_obj")
    REFERENCES "objects"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT "fk_content_fields"
    FOREIGN KEY("id_field")
    REFERENCES "fields"("id")
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT "fk_rel_object"
    FOREIGN KEY("val_rel_obj")
    REFERENCES "objects"("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT "fk_rel_element"
    FOREIGN KEY("val_rel_elem")
    REFERENCES "elements"("id")
    ON DELETE SET NULL
    ON UPDATE CASCADE
);
CREATE INDEX "content.fk_content_objects" ON "content"("id_obj");
CREATE INDEX "content.fk_content_fields" ON "content"("id_field");
COMMIT;
