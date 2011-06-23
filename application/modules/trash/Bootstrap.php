<?php
/**
 * 
 * Bootstrap модуля Trash
 *
 * @category   Xcms
 * @package    Content
 * @version    $Id: $
 */

class Trash_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Корзина',
		'type'       => 'tree',
		'controller' => 'trash',
		'layout' => array(
			'type' => 'pane',
			'panes' => array(
				array(
					'element' => 'element',
				)
			)
		),
		'actions' => array(
			'element'=> array(
				'delete' => 'Удалить страницу',
				'edit' => 'Востановить страницу'
			)
		),
		'widjet' => 'tree',
		'is_core' => true,
		'viewform' => 'panel'
	);
	
	/**
	 * Инициализация маршрутизатора модуля
	 * @return void
	 */
    protected function _initRoutes() {
		$front = $this->getApplication ()->getResource ( 'frontcontroller' );
		$router = $front->getRouter ();
		$name = $this->_moduleOptions['controller'];
		$router->addRoute ( "admin_$name", new Zend_Controller_Router_Route ( 
			"admin/$name/:action/*", 
			array (
				'module' => $name,
				'controller' => 'back'
			)
		) );
	}
	
	/**
	 * Возвращает свойства модуля
	 * @return array
	 */
	public function getModuleOptions() {
		return $this->_moduleOptions;
	}
}