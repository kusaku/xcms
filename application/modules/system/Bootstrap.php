<?php
/**
 * 
 * Bootstrap модуля обратной связи
 *
 * @category   Xcms
 * @package    Install
 * @version    $Id: Bootstrap.php 231 2010-06-24 13:56:27Z alex $
 */

class System_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Система',
		'controller' => 'system',
		'type'       => 'tree',
		'types'      => array(
			array(
				'element' => 'system',
			),
		),
                'layout'=> array(
                    'type'=> 'tabs',
                    'panes'=> array(
                        array(
                            'title'=> 'Модули',
                            'element'=> 'smodule',
                            'addtoroot'=> array(
                                'title' => 'Установить новый модуль'
                            ),
			    'widjet'=>'tree'
                        ),
                        array(
                            'title'=> 'Снимки Базы данных',
                            'element'=> 'dumps',
                            'addtoroot'=> array(
                                'title' => 'Сделать снимок БД'
                            ),
			    'widjet'=>'tree'
                        ),
                    ),
                ),
                'actions'=>array(
                    'dumps'=>array(
                            'delete' => 'Удалить дамп'
                    ),
                    'smodule'=>array(
                            'delete' => 'Удалить модуль'
                    ),
                ),
                'widjet'=>'tree',
                'viewform' => 'dialog',
		'addtoroot' => true,
                'is_core' => true
	);
	
	/**
	 * Инициализация маршрутизатора модуля
	 * @return void
	 */
    protected function _initRoutes() {
		$front = $this->getApplication ()->getResource ( 'frontcontroller' );
		$router = $front->getRouter ();
		$name = $this->_moduleOptions['controller'];
		$router
			->addRoute ( "admin_$name", new Zend_Controller_Router_Route ( 
			"admin/$name/:action/*", 
				array (
					'module' => $name,
					'controller' => 'back'
				)
			) );
			
			;
	}
	
	/**
	 * Возвращает свойства модуля
	 * @return array
	 */
	public function getModuleOptions() {
		return $this->_moduleOptions;
	}
}
