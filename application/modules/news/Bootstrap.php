<?php
/**
 * 
 * Bootstrap модуля News
 *
 * @category   Xcms
 * @package    News
 * @version    $Id: Bootstrap.php 254 2010-08-03 13:37:54Z igor $
 */

class News_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Новости',
		'type'       => 'tree_expanded',
		'controller' => 'news',
                'layout' => array(
                    'panes' => array(
                            array(
                                'element' => 'category',
                                'addtoroot' => array(
                                    'title' => 'Добавить'
                                ),
                            ),
                            array(
                                'element' => 'element',
                            )
                        )
                    ),
		/*'types'      => array(
			array(
				'element' => 'category',
				'actions' => array(
					'delete' => 'Удалить ленту новостей',
					'edit'   => 'Редактировать ленту новостей',
			        'new'    => 'Создать новость'
				)
			),
			array(
				'element' => 'element',
				'actions' => array(
					'delete' => 'Удалить новость',
					'edit'   => 'Редактировать новость',
				)
			)
		),*/
                'actions' => array(
                    'category' => array(
                        'delete' => 'Удалить ленту новостей',
                        'edit'   => 'Редактировать ленту новостей',
                        'newitem'    => 'Создать новость',
                    ),
                    'element' => array(
                        
                        'delete' => 'Удалить новость',
                        'edit'   => 'Редактировать новость',
                    )
                ),
                'viewform' => 'panel',
                'widjet' => 'tree',
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
		$router->addRoute ( 'news_category', new Zend_Controller_Router_Route ( 
			'news/category/:id', 
			array (
				'module' => 'news',
				'controller' => 'category',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'news_category_page', new Zend_Controller_Router_Route ( 
			'news/category/:id/:page', 
			array (
				'module' => 'news',
				'controller' => 'category',
				'action' => 'view',
				'page'   => 0
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'news_archive', new Zend_Controller_Router_Route ( 
			'news/category/:id/:archive/', 
			array (
				'module' => 'news',
				'controller' => 'category',
				'action' => 'view'
			),
			array(
				'id' => '\d+',
				'archive' => 'archive'
			)
		) );
		$router->addRoute ( 'news_archive_page', new Zend_Controller_Router_Route ( 
			'news/category/:id/:archive/:page/', 
			array (
				'module' => 'news',
				'controller' => 'category',
				'action' => 'view',
				'page'   => 0
			),
			array(
				'id' => '\d+',
				'archive' => 'archive'
			)
		) );
		$router->addRoute ( 'news_item', new Zend_Controller_Router_Route ( 
			'news/item/:id', 
			array (
				'module' => 'news',
				'controller' => 'item',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'rss_alias', new Zend_Controller_Router_Route (
			':urlname/:rss/:page',
			array (
				'module'     => 'content',
				'controller' => 'index',
				'action'     => 'alias',
				'page'       => 0
			),
			array(
				// Исключаем обращение к модулям типа: /admin
				'urlname' => '(?-i)[^admin]\S*', // не начинается на прописную латинскую букву
				'page'    => '\d*',
				'rss' => 'rss'
			)
		) );
		$router->addRoute ( 'archive_alias', new Zend_Controller_Router_Route ( 
			':urlname/:archive/:page', 
			array (
				'module'     => 'content',
				'controller' => 'index',
				'action'     => 'alias',
				'page'       => 0
			),
			array(
				// Исключаем обращение к модулям типа: /admin
				'urlname' => '(?-i)[^admin]\S*', // не начинается на прописную латинскую букву
				'page'    => '\d*',
				'archive' => 'archive'
			)
		) );
	}
	
	/**
	 * Возвращает свойства модуля
	 * @return array
	 */
	public function getModuleOptions() {
		$config = Zend_Registry::get( $this->_moduleOptions['controller'] );
		$max = (int) $config->maxcats;
		if ( !empty($max) ) {
			$this->_moduleOptions['maxpages'] = $max;
			// Убираем кнопку "Добавить" из корня, если кол.страниц контента больше разрешенного
			$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('news', 'category');
			if ( isset($type) ) {
				$total_pages = Model_Collection_Elements::getInstance()->countElementsByType($type->id);
				if ( $total_pages >= $max ) {
					$this->_moduleOptions['addtoroot'] = false;
				}
			}
		}
		return $this->_moduleOptions;
	}
}
