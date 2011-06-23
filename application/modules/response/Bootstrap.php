<?php
/**
 * 
 * Bootstrap модуля Response
 *
 * @category   Xcms
 * @package    Response
 * @version    $Id:
 */

class Response_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Отзывы',
		'type'       => 'response',
		'controller' => 'response',
		'addtoroot' => true,
		'is_core' => false
	);
	
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
		$router->addRoute ( 'response_category', new Zend_Controller_Router_Route ( 
			'response/category/:id', 
			array (
				'module' => 'response',
				'controller' => 'category',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'response_category_page', new Zend_Controller_Router_Route ( 
			'response/category/:id/:page', 
			array (
				'module' => 'response',
				'controller' => 'category',
				'action' => 'view',
				'page'   => 0
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'response_item', new Zend_Controller_Router_Route ( 
			'response/item/:id', 
			array (
				'module' => 'response',
				'controller' => 'item',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'response_alias', new Zend_Controller_Router_Route ( 
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