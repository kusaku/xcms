<?php
/**
 * 
 * Bootstrap модуля Gallery
 *
 * @category   Xcms
 * @package    Catalog
 * @version    $Id:
 */

class Gallery_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Галерея',
		'controller' => 'gallery',
		'layout' => array(
			'type' => 'pane',
			'panes' => array(
				array(
					'element' => 'category',
					'addtoroot' => array(
						'title' => 'Создать категорию'
					)
				),
				array(
					'element' => 'item'
				)
			)
		),
		'actions' => array(
			'category' => array(
				'delete' => 'Удалить категорию галереи',
				'edit'   => 'Редактировать категорию галереи',
				'newitem'    => 'Создать элемент галереи',
				'new'   => 'Создать категорию',
			),
			'item' => array(
				'delete' => 'Удалить элемент галереи',
				'edit'   => 'Редактировать элемент галереи',
			)
		),
		'widjet' => 'tree',
		'viewform' => 'panel',
		'update_tree' => true,
		'addtoroot' => true,
		'is_core' => false
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
		/*$router->addRoute ( 'home', new Zend_Controller_Router_Route ( 
			'/', 
			array (
				'module'     => 'gallery',
				'controller' => 'category',
				'action'     => 'view'
			)
		) );*/
		$router->addRoute ( 'gallery_category', new Zend_Controller_Router_Route ( 
			'gallery/category/:id', 
			array (
				'module' => 'gallery',
				'controller' => 'category',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'gallery_category_page', new Zend_Controller_Router_Route ( 
			'gallery/category/:id/:page', 
			array (
				'module' => 'gallery',
				'controller' => 'category',
				'action' => 'view',
				'page'   => 0
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'gallery_alias', new Zend_Controller_Router_Route ( 
			':urlname/:page/', 
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
