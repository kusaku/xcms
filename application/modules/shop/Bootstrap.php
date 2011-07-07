<?php
/**
 * 
 * Bootstrap модуля Templates
 *
 * @category   Xcms
 * @package    Templates
 * @version    $Id: Bootstrap.php 392 2010-09-16 11:46:24Z igor $
 */

class Shop_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Магазин',
		'controller' => 'shop',
            'layout'=> array(
                    'type'=> 'tabs',
                    'panes'=> array(
                        array(
                            'title'=> 'Каталог магазина',
                            'element'=> 'category',
                            'addtoroot'=> array(
                                'title' => 'Добавить'
                            ),
                            'widjet' => 'tree'
                        ),
                        array(
                            'title'=> 'Заказы',
                            'element'=> 'orders',
                            'widjet' => 'table',
                            'subelement' =>'orderinfo'
                        ),
                        array(
                            'title'=> 'Клиенты',
                            'element'=> 'users',
                            'widjet' => 'table',
                            'subelement' => 'userorders'
                        )
                    )
                ),
            'widjet'=>'tree',
            'viewform' => 'panel',
            'actions' => array(
                    'category'=>array(
                            'edit' => 'Редактировать',
                            'newsub'   => 'Создать категорию',
                            'newitem'    => 'Создать товар',
                            'delete' => 'Удалить',
                    ),
                    'orders'=>array(
                        'edit'=>'Редактировать товар',
                        'delete'=>'Удалить товар'
                    )
            ),
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
		$router->addRoute ( 'shop_category', new Zend_Controller_Router_Route (
			'shop/category/:id',
			array (
				'module' => 'shop',
				'controller' => 'category',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
                $router->addRoute ( 'shop_search', new Zend_Controller_Router_Route (
			'shop/search/:category/:field/:query',
			array (
				'module' => 'shop',
				'controller' => 'search',
				'action' => 'view'
			),
                        array(
                            'category' => '\d+',
                            'field' => '\w+',
                            'query' => '\w+'
                        )
		) );
		$router->addRoute ( 'shop_category_page', new Zend_Controller_Router_Route (
			'shop/category/:id/:page',
			array (
				'module' => 'shop',
				'controller' => 'category',
				'action' => 'view',
				'page'   => 0
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'shop_item', new Zend_Controller_Router_Route (
			'shop/item/:id',
			array (
				'module' => 'shop',
				'controller' => 'item',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
                $router->addRoute ( 'shop_cart', new Zend_Controller_Router_Route (
			'shop/cart',
			array (
				'module' => 'shop',
				'controller' => 'order',
				'action' => 'view',
                                'id' => 0
			),
			array(
				'id' => '\d+'
			)
		) );
                
		$router->addRoute ( 'shop_alias', new Zend_Controller_Router_Route (
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
