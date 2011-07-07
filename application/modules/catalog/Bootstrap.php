<?php
/**
 * 
 * Bootstrap модуля Catalog
 *
 * @category   Xcms
 * @package    Catalog
 * @version    $Id:
 */

class Catalog_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title' => 'Каталог',
		'controller' => 'catalog',
		'layout' => array(
                    'type' => 'pane',
                    'panes' => array(
                        array(
                            'element' => 'category',
                            /*'actions'  => array(
                                    'edit' => 'Редактировать',
                                    'delete' => 'Удалить'
                            ),*/
                            'addtoroot' => array(
                                    'title' => 'Добавить'
                            )
                        ),
                        array(
                            'element' => 'item',
                        ),
                    )
		),
		'widjet' => 'tree',
                'actions'  => array(
                    'category'=>array(
                            'edit' => 'Редактировать',
                            'newsub'   => 'Создать категорию',
                            'newitem'    => 'Создать товар',
                            'delete' => 'Удалить',
                    ),
                    'item'=>array(
                        'edit'=>'Редактировать товар',
                        'delete'=>'Удалить товар'
                        )
                ),
		'viewform' => 'panel',
		'update_tree' => true,
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
		$router->addRoute ( 'catalog_category', new Zend_Controller_Router_Route ( 
			'catalog/category/:id', 
			array (
				'module' => 'catalog',
				'controller' => 'category',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
                $router->addRoute ( 'catalog_search', new Zend_Controller_Router_Route (
			'catalog/search/:category/:field/:query',
			array (
				'module' => 'catalog',
				'controller' => 'search',
				'action' => 'view'
			),
                        array(
                            'category' => '\d+',
                            'field' => '\w+',
                            'query' => '\w+'
                        )
		) );
		$router->addRoute ( 'catalog_category_page', new Zend_Controller_Router_Route ( 
			'catalog/category/:id/:page', 
			array (
				'module' => 'catalog',
				'controller' => 'category',
				'action' => 'view',
				'page'   => 0
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'catalog_item', new Zend_Controller_Router_Route ( 
			'catalog/item/:id', 
			array (
				'module' => 'catalog',
				'controller' => 'item',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'catalog_alias', new Zend_Controller_Router_Route ( 
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