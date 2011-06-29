<?php
/**
 *
 * Bootstrap модуля Search
 *
 * @category   Xcms
 * @package    Search
 * @author     kifirch
 */

class Extsearch_Bootstrap extends Zend_Application_Module_Bootstrap {

	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Расширенный поиск',
		'controller' => 'extsearch',
		'is_core' => false
	);

	/**
	 * Инициализация маршрутизатора модуля
	 * @return void
	 */
    protected function _initRoutes() {
		$front = $this->getApplication ()->getResource ( 'frontcontroller' );
		$router = $front->getRouter ();
		$router->addRoute ( 'extsearch', new Zend_Controller_Router_Route (
			'extsearch/',
			array (
				'module' => 'extsearch',
				'controller' => 'index',
				'action' => 'view'
			)
			
		) );
		$router->addRoute ( 'extsearch_alias', new Zend_Controller_Router_Route (
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