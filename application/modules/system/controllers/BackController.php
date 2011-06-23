<?php
/**
 * Backend контроллер установщика
 *
 * @author alex
 * @version
 */

class System_BackController extends Xcms_Controller_Back {

	/**
	 * Расширение файла Дампа БД
	 * @var string
	 */
	protected $_ext = ".sql";



        /**
         * Выясяем с чем работаем
         */
        public function  preDispatch() {
            $module = $this->getRequest()->getParam('module');
            $dump = $this->getRequest()->getParam('dumps');
            if( isset($module) ) $this->type = 1; 
            if( isset($dump) ) $this->type = 2;
        }

	/**
         * Списки
         */
        public function getAction() {
            switch( $this->type ) {
                case 1: // Модули
                    $elements = $this->getAllModules();
                    break;
                case 2:
                    $elements = $this->getAllDumps();
                    break;
            }
            $this->getResponse()->setBody( $this->view->json( $elements ) );
	}

        /**
         * Получение списка дампов
         * @return array
         */
	public function getAllDumps() {
            $dir = opendir(APPLICATION_PATH.'/../data/db');
            $values = array();
            $i = 1;
	    $bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
	    $options = $bootstraps['system']->getModuleOptions();
	    $actions = $options['actions'];
            while (false !== ($file = readdir($dir))) {
                    if( substr( $file ,-4 , 4) == $this->_ext) {
                        $values[$i]['id'] = $i;
                        $values[$i]['title'] = $file;
			$values[$i]['controller'] = 'system';
			$values[$i]['element'] = 'dumps';
			$values[$i]['actions'] = $actions['dumps'];
                    $i++;
                    }
	    }
	    /*foreach($values as $k=>$v) {
	    	$values[$k]['id'] =  array(1,$k);
                $values[$k]['expandable'] = false;
                $values[$k]['fields'] = array();
                $values[$k]['elementClass'] = 'file';
	    }*/
	    closedir($dir);
	    return $values;
	}


        /**
         * Получение списка установленных модулей
         * @return array
         */
        public function getAllModules() {
            $bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
	    $options = $bootstraps['system']->getModuleOptions();
	    $actions = $options['actions'];
            $modules = array();
            $i=1;
            $mcet = Model_Collection_ElementTypes::getInstance();
            $db = $mcet->getDbElementTypes();
            foreach ($bootstraps as $name => $module) {

                if ( method_exists( $bootstraps[ $name ], 'getModuleOptions' ) ) {
                    $options = $module->getModuleOptions();
                    //var_dump($options);
                    $row = $db->select()->where('module=?',$options['controller']);
                    $result = $row->query();
                    if($result->rowCount() > 0){
                        $modules[$i] = array(
                        'id'=> $i,
                        'title'=>$options['title'],
                        'elementClass'=>'module',
                        'fields' => array(),
						'element' => 'smodule',
						'controller' => 'system',
						'actions' => $actions['smodule'],
                        'is_locked' => $options['is_core'],
                        'ctrllr' => $options['controller']
                        );
                        $i++;
                    }
                }

            }
            return $modules;
        }

        /**
         * Удаление
         */
		public function deleteAction() {
			$request = $this->getRequest();
			$dumpId = $request->getParam("dumps");
			$moduleId = $request->getParam("smodule");
			if ( !empty($dumpId) ) {
				$this->deleteDump($dumpId);
			} elseif ( !empty($moduleId) ) {
				$this->uninstallModule($moduleId);
			}
		}

        /**
         * Удаление дампа
         * @param int $id
         */

        public function deleteDump($id) {
            $files = $this->getAllDumps();
            unlink(APPLICATION_PATH.'/../data/db/'.$files[$id]['title']);
        }

        /**
         * Удаление модуля из системы
         * @param <type> $id
         */
        public function uninstallModule($id) {
            $modules = $this->getAllModules();
            $controller = $modules[$id]['ctrllr'];
            if (Model_ModuleInstaller::uninstall($controller) ) {
                //$this->getResponse()->setBody(1);
            } else {
                //$this->getResponse()->setBody(0);
            }
        }

        public function uploadmoduleAction() {
            $result = Model_ModuleInstaller::unpackModule();
            if ( $result === true) {
                $this->getResponse()->setBody("Модуль успешно установлен");
            } else {
                $this->getResponse()->setBody( $result );
            }

        }

        /**
	 *
	 * Форма создания дампа БД
	 */
	public function newAction() {
            $this->_forward('edit');
	}


	/**
	 * Скачивание файла дампа
	 * Enter description here ...
	 */
	public function linkAction() {
		/*$filename = $this->getRequest()->get
		if(isset($_SERVER['HTTP_USER_AGENT']) and strpos($_SERVER['HTTP_USER_AGENT'],'MSIE'))
			Header('Content-Type: application/force-download');
		else
			Header('Content-Type: application/octet-stream');
		 Header('Accept-Ranges: bytes');
		 Header('Content-Length: '.strlen($string));
		 Header('Content-disposition: attachment; filename="products.txt"');*/
	}

	/**
	 * Форма создания дампа БД
	 */
	public function editAction() {
            $request = $this->getRequest();
             switch( $this->type ) {
                case 1: // Модули
                    $form = new System_Form_Module();
                    if ( $request->isPost() ) {
                        $form->populate($request->getPost());
                    }
                    $params = array();
                    $params[] = 'admin';
                    $params[] = 'system';
                    $params[] = 'uploadmodule';
                    $data['id'] = 0;
                    $data['params'] = $params;
                    $data['title'] = 'Добавление модуля в систему';
                    $data['form'] = ( string ) $form;
                    break;
                case 2: // БД
                    $form = new System_Form_Prepare();
                    if ( $request->isPost() ) {
                        print_r($request->getPost());
                            if ( $form->isValid( $request->getPost() )) {
                                $data['error'] = $this->createNativeMySqlDump( $request->getParam('prepare') );
                            } else {
                                $data['error'] = false;
                                $form->populate($request->getPost());
                            }
                    }
                    $data['id'] = 0;
                    $data['title'] = 'Создание снимка БД';
                    $data['form'] = $form->__toString();
                    break;
            }
           // $this->getResponse()->setBody( $this->view->json( $data ) );
           /* $form = new Admin_Form_Edit();
            $id = $this->type;
            if( $id == 2 ) {
                $file = $this->getRequest()->getParam('file');
                if( is_null( $file ) ) {
                    $form->addElement('hidden', 'element',
                    array('value'=>1));
                    $form->addDisplayGroup(array('element'), 'dumps', array('description' => 'Снимки базы данных' ));
                    $form->addDisplayGroupButtons( 'dumps' ,'cancel');
                    $form->addDisplayGroup(array('element'), 'ms', array('description' => 'Вернуться назад') );
                    $form->addDisplayGroupButtons( 'ms' ,'cancel');
                } else {
                    //$this->_forward('new');
                }
            } elseif( $id == 1 ) {
                $form->addElement('hidden', 'element',
                array('value'=>2));
                $form->addDisplayGroup(array('element'), 'modules',array('description' => 'Модули системы' ));
                $form->addDisplayGroup(array('element'), 'ms', array('description' => 'Вернуться назад') );
                $form->addDisplayGroupButtons( 'ms' ,'cancel');
                
            }*/

            $data['form'] = $form->render();
            $this->getResponse()->setBody( $this->view->json( $data ) );
            //$this->_forward('new');
	}

        /**
         * Проверка на int
         * @param <type> $var
         */
        private function is_true_integer($var) {
            $res=false;
            if(is_numeric($var)){
                    $arr = explode('.',$var);
                    if(count($arr)==1) $res = true;
            }
            return $res;
        }

	/**
	 *
	 * Создание дампа БД.
	 * @param string $dump_file - имя файла
	 */
        public function createNativeMySqlDump( $dump_file ) {
            $db = Zend_Db_Table_Abstract::getDefaultAdapter();
            $db_config = $db->getConfig();
            $filename = APPLICATION_PATH.'/../data/db/'.$dump_file.$this->_ext;
            if( file_exists($filename) ) {
                    return false;
            }

            $fdump = fopen($filename,"w+");

            $dbname = $db_config['dbname'];
            $res = $db->getConnection();
            $tables = $db->query('SHOW TABLES');
            $tables = $tables->fetchAll(null,1);
            $data['create'] = array();
            foreach ( $tables as $table ) {
                $listOfTables[] = $table['Tables_in_'.$dbname];
            }

            $foreignKey = '|CONSTRAINT(.*)FOREIGN KEY(.*)REFERENCES(.*)ON DELETE(.*)ON UPDATE(.*)|';

            fwrite($fdump,"set foreign_key_checks = 0;\n\n");
            //Формирование запросов на создание таблиц
            foreach ($listOfTables as $table) {
                fwrite($fdump,"\n-- TABLE ".$table."\n\n");
                $create = $db->query('SHOW CREATE TABLE '.$table);
                $create = $create->fetch();
                $str = $create["Create Table"].";\n";
                $data['create'][$table] = $create["Create Table"];
                preg_match_all($foreignKey, $str, $matches);
                $data['alter'][$table] = $matches[0];
                $str = preg_replace($foreignKey,' ',$str);
                $str = preg_replace('|,[\s\r\n]*\)|',')',$str);
                fwrite($fdump,"\nDROP TABLE IF EXISTS `".$table."`;\n\n");
                fwrite($fdump,$str);
            }

            //Формирование запросов на вставку данных
                foreach ($listOfTables as $table) {
                fwrite($fdump,"\n-- DATA FOR TABLE ".$table."\n\n");
                    $insert = $db->query('SELECT * FROM '.$table);
                    $insert = $insert->fetchAll();
                    $res = $db->getConnection();

                    foreach ($insert as $ins) {
                        $values = '';
                        foreach($ins as $val){
                            if( $val===NULL ) {
                                $values[] = "NULL";
                            } elseif($this->is_true_integer($val) && strlen($val) < 11 ) {
                                $values[] = $val;
                            } else {
                                $values[] = "'".str_replace("'","''",$val)."'";
                            }
                        }
                        $str = "INSERT INTO ".$table."(".join(",",array_keys($ins))
                                .")	VALUES(".join(",",$values).");\n";
                        $data['insert'][$table][] = $str;
                        fwrite($fdump,$str);
                    };
            }

            //Формирование запросов на добавление ключей

            foreach ($listOfTables as $table) {
                    fwrite($fdump,"\n-- ALTER TABLE ".$table."\n\n");
                    if(count($data['alter'][$table])>0) {
                            $sql = "ALTER TABLE ".$table
                            ." ADD ".join("\nADD ",$data['alter'][$table]).";\n";
                            fwrite($fdump,$sql);
                    }

            }
            fwrite($fdump,"\nset foreign_key_checks = 1;\n\n");
            fclose($fdump);
            return true;
        }

	/**
	 * Создает дамп базы при помощи утилиты
	 * mysqldump
	 */
        public function createProgMySqlDump() {
            $db_config = Zend_Registry::get('resources');
            $db = $db_config->db->params;
            system('mysqldump -h '.$db->host.'
            -u '.$db->username.'
            -p'.$db->password.' '.$db->dbname.'
             -r D:\data.sql',$s);
            return (string) $s;
            //$this->getResponse()->setBody($this->view->json($str));
        }

}

