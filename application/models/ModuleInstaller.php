<?php
class Model_ModuleInstaller {

    /**
     *
     * @var Zend_Db_Adapter
     */
    protected static $_db;

    private static $type_id;

    /**
     * Загрузка данных в БД из файла data.xml
     * @param Simple_XML_Object $elem
     * @param int $id - parent_id
     */
    private function  parse_into($elem ,$id){
        foreach ($elem as $key=>$values) {
            $table = $key;
            $attribs = $values->attributes();
            $data = array();
            foreach ($attribs as $col=>$value) {
                if ($value == "parent") {
                    $value = $id;
                }
                if ($value=="?") {
                    $value = self::$type_id;
                }
                if(!empty($value) && $value!='')
                	$data[$col] = (string)$value;
            }
            //print_r($data);
            $i = self::$_db->insert($table,$data);
            if(count($values->children())>0) {
                if($table == 'element_types') self::$type_id = self::$_db->lastInsertId();
                self::parse_into($values,  self::$_db->lastInsertId());
            } else {
                //print($key);
            }
        }
    }

    /**
     * Проверка наличия файлов в директории модуля
     * @param Simple_XML_Object $xml
     */
    private function check_options($module) {
        foreach($module->options->files as $files) {
            $attr = $files->attributes();
            $module_path = APPLICATION_PATH."/".$attr->path;
            foreach($files->file as $file){
                if(file_exists($module_path.$file->attributes()->path.$file) ){
                    //print($module_path.$file->attributes()->path.$file);
                } else {
                    return "Неполный архив модуля";
                }
            }
        }
        return true;
    }

    /**
     * Рекурсивное удаление директории с содержимым
     * @param string $dir 
     */
    public static function removeDirRec($dir)
    {
        if ( $objs = glob($dir."/*") ) {
            foreach($objs as $obj) {
                is_dir($obj) ? self::removeDirRec($obj) : unlink($obj);
            }
        }
        @rmdir($dir);
    }

    /**
     * Перемещение директории
     * @param string $dir
     */
    public static function recurseMove($src,$dst) {
        $dir = opendir($src);
        @mkdir($dst);
        while(false !== ( $file = readdir($dir)) ) {
            if (( $file != '.' ) && ( $file != '..' )) {
                if ( is_dir($src . '/' . $file) ) {
                    self::recurseMove($src . '/' . $file,$dst . '/' . $file);
                    rmdir($src . '/' . $file);
                }
                else {
                    @copy($src . '/' . $file,$dst . '/' . $file);
                    @unlink($src . '/' . $file);
                }
            }
        }
        closedir($dir);
    }


    /**
     * Установка модуля в систему
     * @param string $module - имя модуля
     * @return bool
     */
    public static function install($module,$controller = null) {
        
        $mcet = Model_Collection_ElementTypes::getInstance();
        self::$_db = $mcet->getDbElementTypes()->getAdapter();
        // Смотрим, есть ли уже модуль в системе
        $result = self::$_db->select()->from('element_types')->where('module=?',$module);
        $c = $result->query();
        if( $c->rowCount()>0 && is_null($controller)) {
            Main::logDebug('Уже тут');
            return "Модуль уже установлен";
        } elseif($controller) {
            $result = self::$_db->select()->from('element_types')->where('module=?',$module)->where('controller=?',$controller);
            $c = $result->query();
            if($c->rowCount()>0) {
                Main::logDebug('Уже тут');
                return "Плагин";
            }
        }
        // Подцепляем файл с настройками
        $xml_options = simplexml_load_file(APPLICATION_PATH."/modules/".$module."/install/options.xml");
        if( ! self::check_options($xml_options) ) {
            Main::logDebug('Опции не прошли');
            return "Неверный архив";
        }
        // Подцепляем файл с данными
        $xml = simplexml_load_file(APPLICATION_PATH."/modules/".$module."/install/data.xml");
        self::$_db->query("set foreign_key_checks = 0");
        self::$_db->beginTransaction();
        try {
            self::parse_into($xml,0);
        } catch (Exception $e) {
            //Main::logDebug($e->getMessage());
            self::$_db->rollback();
            return "Ошибка при записи в БД";
        }
        self::$_db->commit();
        self::$_db->query("set foreign_key_checks = 1");
        self::$_db->closeConnection();
        unset($xml);
        return true;
    }

    /**
     * Удаление модуля из системы
     * @param string $module - имя модуля
     * @todo - переделать под структуру БД
     * все ключи must be  ON DELETE CASCADE
     * или засунуть все в одну транзакцию, что
     * пока не представляется возможным.
     */
    public static function uninstall($module) {
        // При изменении модели данных
        /* $mcet = Model_Collection_ElementTypes::getInstance()->getDbElementTypes();
        try {
            $mcet->delete("module='".$module."'");
        } catch (Exception $e) {
            print $e->getMessage();
            return;
        }
        */

        // Для старой модели данных
        $mcet = Model_Collection_ElementTypes::getInstance();
        $mcot = Model_Collection_ObjectTypes::getInstance();
        $mce  = Model_Collection_Elements::getInstance();
        $mco  = Model_Collection_Objects::getInstance();
        $mcf  = Model_Collection_Fields::getInstance();

        $et = $mcet->getModuleElementType('catalog','item');
        $items = $mce->getElementsByType($et->id);
        foreach($items as $elem) {
            $elem->delete();
        }
        $e  = $mce->getDbElements(); // elements
        $o  = $mco->getDbObjects(); // objects
        $c  = $mco->getDbContent(); // content
        $et = $mcet->getDbElementTypes(); // element_types
        $ot = $mcot->getDbObjectTypes(); // object_types
        $pm = $mcet->getDbPermissionsModules(); // permission_modules
        $fg = $mcot->getDbFieldGroups(); // field_groups
        $fc = $mcf->getDbFieldsController(); // fields_controller
        $db = $et->getAdapter();
        //$db->exec('set foreign_key_checks = 0');
        // Тут и далее по коду Магия Zend_Db
        $element_types = $et->fetchAll(
                        $et->select()->where('module=?',$module)
                    )->toArray();
        rsort($element_types);
        foreach ($element_types as $etype) {
            $ids = $e->fetchAll(
                        $e->select()->where('id_type=?',$etype['id'])
                    );
            $object_types[] = $ot->fetchAll(
                        $ot->select()->where('id_element_type=?',$etype['id'])
                    )->toArray();
            foreach($ids as $elem) {
                if ( ! empty( $elem->id ) ) {
                    try {
                        $mce->delEntity($elem->id);
                        $db->commit(); // На всякий случай.
                        // @TODO - Проверять начата ли транзакция. (выяснить как это сделать)
                    } catch (Exception $error) {
                        print "166".$error->getMessage();
                    }
                }
            }
        }
        // Всегда начинаем с самого последнего элемента
        rsort($object_types);
        foreach ($object_types as $otype) {
            for($i=0;$i<count($otype);$i++) {
                $ids = $o->fetchAll(
                            $o->select()->where('id_type=?',$otype[$i]['id'])
                        );
                foreach($ids as $elem) {
                    if( ! empty( $elem->id ) ) {
                        try {
                            $mco->delEntity($elem->id);
                        } catch (Exception $error) {
                            print "186".$error->getMessage();
                        }
                    }
                }
                try {
                    $mcot->delEntity($otype[$i]['id']);
                    $ot->getAdapter()->commit();
                } catch (Exception $error) {
                    print "190".$error->getMessage();
                }
            }
            
        }
        foreach ($element_types as $elem) {
            try {
                $pm->delete("id_etype='".$elem['id']."'");//@TODO Почему тут так?
                $mcet->delEntity($elem['id']);//@TODO А тут - так?
            } catch (Exception $error) {
                print "202".$error->getMessage();
            }
        }
        // Конец магии - так проще и надежнее.
        $db->exec('delete from field_groups where id_obj_type not in (select id from object_types)');
        $module_path = APPLICATION_PATH.'/modules/'.$module;
        $template_path = APPLICATION_PATH.'/../templates/scripts/'.$module;
        self::removeDirRec($module_path);
        self::removeDirRec($template_path);
        return true;
    }

    /**
     * Распаковка zip-архива с файлами модуля
     * @return bool
     */
    public static function unpackModule() {
        $file = $_FILES['userfile']['tmp_name'];
        $zip = new ZipArchive();
        $zip->open($file);
        $comment = $zip->getArchiveComment();
        if (substr($comment, 0,12) == 'xcms_module_') {
            $module = substr($comment,12);
            $strc = explode("_",$module);
            if(count($strc) == 1) {
                $module = $module;
                $controller = null;
            } else {
                $module = $strc[0];
                $controller = $strc[1];
            }
        } else {
            return "Это не архив модуля";
        }

        $module_path = APPLICATION_PATH.'/modules/'.$module;
        if(! file_exists($module_path) ) {
            //return "Директория модуля уже существует";
            if( !mkdir($module_path) ) {
                return 'Ошибка создания директории';
            }
        }
        @chmod($module_path, 0777);
        $template_path = APPLICATION_PATH.'/../templates/scripts';
        
        if(!$zip->extractTo($module_path)) {
            return "Ошибка распаковки архива";
        }
        $dir = opendir($module_path);
        while (false !== ($file = readdir($dir)))  {
            if($file == 'library') {
                self::recurseMove($module_path.'/library', APPLICATION_PATH.'/../library');
            }
            if($file == 'templates') {
                self::recurseMove($module_path.'/templates/scripts', $template_path);
            }
        }
        $zip->close();
        $res = self::install($module,$controller);
        return $res;
    }
}
