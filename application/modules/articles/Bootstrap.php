<?php
/**
 * 
 * Bootstrap модуля Articles
 *
 * @category   Xcms
 * @package    Articles
 * @version    $Id:
 */

class Articles_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Статьи',
		//'type'       => 'tree_expanded',
		'controller' => 'articles',
		//'types'      
                'layout' => array(
                    'type' => 'pane',
                    'panes' => array(
			array(
				'element' => 'category',
                                'addtoroot'=>array('title'=>'Создать ленту статей')
			),
			array(
				'element' => 'item',
			)
		)),
                'actions'=> array(
                  'category'  => array(
                      'delete' => 'Удалить ленту статей',
                      'edit'   => 'Редактировать ленту статей',
                      'newitem' => 'Создать статью'
                      ),
                    'item' => array(
					'delete' => 'Удалить статью',
					'edit'   => 'Редактировать статью',
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
		$router->addRoute ( 'articles_category', new Zend_Controller_Router_Route ( 
			'articles/category/:id', 
			array (
				'module' => 'articles',
				'controller' => 'category',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'articles_category_page', new Zend_Controller_Router_Route ( 
			'articles/category/:id/:page', 
			array (
				'module' => 'articles',
				'controller' => 'category',
				'action' => 'view',
				'page'   => 0
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'articles_item', new Zend_Controller_Router_Route ( 
			'articles/item/:id', 
			array (
				'module' => 'articles',
				'controller' => 'item',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
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