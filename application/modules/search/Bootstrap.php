<?php
/**
 *
 * Bootstrap модуля Search
 *
 * @category   Xcms
 * @package    Search
 * @author     kifirch
 */

class Search_Bootstrap extends Zend_Application_Module_Bootstrap {

	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Поиск',
		'controller' => 'search',
		'layout'=> array(
			'type'=> 'pane',
			'panes'=> array(
				array(
					'element' => 'element',
				)
			)
		),
		'widjet' => '',
		'viewform' => 'panel',
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
		$router->addRoute ( "admin_$name", new Zend_Controller_Router_Route (
			"admin/$name/:action/*",
			array (
				'module' => $name,
				'controller' => 'back'
			)
		) );
		$router->addRoute ( 'search', new Zend_Controller_Router_Route (
			'search/',
			array (
				'module' => 'search',
				'controller' => 'index',
				'action' => 'view'
			)
			
		) );
                $router->addRoute ( 'search_alias', new Zend_Controller_Router_Route (
			':urlname/:page',
			array (
				'module'     => 'content',
				'controller' => 'index',
				'action'     => 'alias',
				'page'       => 0
			),
			array(
				// Исключаем обращение к модулям типа: /admin
				'urlname' => '(?-i)[^admin]\S*', // не начинается на прописную латинскую букву
				'page'    => '\d*'
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