<?php
/**
 * 
 * Bootstrap модуля Content
 *
 * @category   Xcms
 * @package    Content
 * @version    $Id: Bootstrap.php 394 2010-09-16 11:50:56Z igor $
 */

class Content_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title' => 'Контент',
		'controller' => 'content',
		'layout' => array(
			'type' => 'pane',
			'panes' => array(
				array(
					'element' => 'element',
					'addtoroot' => array(
						'title' => 'Добавить'
					)
				),
			)
		),
		'widjet' => '',
		'actions'  => array(
			'element'=>array(
				'edit' => 'Редактировать',
				'delete' => 'Удалить'
			)
		),
		'viewform' => 'panel',
		'update_tree' => true,
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
				'module'     => $name,
				'controller' => 'back'
			)
		) );
		$router->addRoute ( 'home', new Zend_Controller_Router_Route ( 
			'/', 
			array (
				'module'     => 'content',
				'controller' => 'index',
				'action'     => 'view'
			)
		) );
		$router->addRoute ( 'content_page', new Zend_Controller_Router_Route ( 
			'content/page/:id', 
			array (
				'module'     => 'content',
				'controller' => 'index',
				'action'     => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'content_alias', new Zend_Controller_Router_Route ( 
			':urlname/:page', 
			array (
				'module'     => 'content',
				'controller' => 'index',
				'action'     => 'alias',
				'page'       => 0
			),
			array(
				// Исключаем обращение к модулям типа: /admin
				'urlname' => '^(?!admin)\S*', // не начинается на прописную латинскую букву
				'page'    => '\d*'
			)
		) );
	}
	
	/**
	 * Возвращает свойства модуля
	 * @return array
	 */
	public function getModuleOptions() {
		$config = Zend_Registry::get( $this->_moduleOptions['controller'] );
		$max = (int) $config->maxpages;
		if ( !empty($max) ) {
			$this->_moduleOptions['maxpages'] = $max;
			// Убираем кнопку "Добавить" из корня, если кол.страниц контента больше разрешенного
			$total_pages = Model_Collection_Elements::getInstance()->countElementsByType(17);
			if ( $total_pages >= $max ) {
				$this->_moduleOptions['addtoroot'] = false;
			}
		}
		if ( !$config->subpages or (!empty($max) and $total_pages >= $max) ) {
			// Убираем кнопки добавления новых страниц из тулбара
			foreach ( $this->_moduleOptions['types'] as $i=>$typelevel ) {
				unset($this->_moduleOptions['types'][$i]['actions']['new']);
				unset($this->_moduleOptions['types'][$i]['actions']['clone']);
				unset($this->_moduleOptions['types'][$i]['actions']['copy']);
			}
		}
		return $this->_moduleOptions;
	}
}
