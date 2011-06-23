<?php
/**
 * 
 * Bootstrap модуля Offers
 *
 * @category   Xcms
 * @package    Offers
 * @version    $Id: Bootstrap.php 254 2010-11-06 13:37:54Z igor $
 */

class Offers_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Акции',
		'controller' => 'offers',
		'layout' => array(
			'type' => 'pane',
			'panes' => array(
				array(
					'element' => 'category',
					'addtoroot' => array(
						'title' => 'Создать ленту акций'
					)
				),
				array(
					'element' => 'item',
				)
			)
		),
		'widjet' => 'tree',
		'actions'  => array(
			'category' => array(
				'delete' => 'Удалить ленту акций',
				'edit'   => 'Редактировать ленту акций',
				'new'    => 'Создать акцию'
			),
			'item' => array(
				'delete' => 'Удалить акцию',
				'edit'   => 'Редактировать акцию'
			)
		),
		'viewform' => 'panel',
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
		$router->addRoute ( 'offers_category', new Zend_Controller_Router_Route ( 
			'offers/category/:id', 
			array (
				'module' => 'offers',
				'controller' => 'category',
				'action' => 'view'
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'offers_category_page', new Zend_Controller_Router_Route ( 
			'offers/category/:id/:page', 
			array (
				'module' => 'offers',
				'controller' => 'category',
				'action' => 'view',
				'page'   => 0
			),
			array(
				'id' => '\d+'
			)
		) );
		$router->addRoute ( 'offers_item', new Zend_Controller_Router_Route ( 
			'offers/item/:id', 
			array (
				'module' => 'offers',
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
		$config = Zend_Registry::get( $this->_moduleOptions['controller'] );
		$max = (int) $config->maxcats;
		if ( !empty($max) ) {
			$this->_moduleOptions['maxpages'] = $max;
			// Убираем кнопку "Добавить" из корня, если кол.страниц контента больше разрешенного
			$type = Model_Collection_ElementTypes::getInstance()->getModuleElementType('offers', 'category');
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
