<?php
/**
 * 
 * Bootstrap модуля Bulletin
 *
 * @category   Xcms
 * @package    Bulletin
 * @version    $Id:
 */

class Bulletin_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Web-доска',
		'type'       => 'response',
		'controller' => 'bulletin',
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
		$router->addRoute ( 'bulletin_category', new Zend_Controller_Router_Route ( 
			'bulletin/category/:id', 
			array (
				'module' => 'bulletin',
				'controller' => 'category',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'bulletin_category_page', new Zend_Controller_Router_Route ( 
			'bulletin/category/:id/:page', 
			array (
				'module' => 'bulletin',
				'controller' => 'category',
				'action' => 'view',
				'page'   => 0
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'bulletin_item', new Zend_Controller_Router_Route ( 
			'bulletin/item/:id', 
			array (
				'module' => 'bulletin',
				'controller' => 'item',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'bulletin_alias', new Zend_Controller_Router_Route ( 
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