<?php
/**
 * 
 * Bootstrap модуля обратной связи
 *
 * @category   Xcms
 * @package    Feedback
 * @version    $Id: Bootstrap.php 416 2010-10-06 12:30:32Z kifirch $
 */

class Feedback_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Обр. связь',
		'controller' => 'feedback',
		'layout' => array(
			'type' => 'pane',
			'panes' => array(
				array(
					'element' => 'element',
					'addtoroot' => array(
						'title' => 'Добавить'
					)
				)
			)
		),
		'widjet' => 'tree',
		'actions'  => array(
			'element'=>array(
				'edit' => 'Редактировать',
				'delete' => 'Удалить'
			)
		),
		'viewform' => 'panel',
		'update_tree' => true,
		'addtoroot' => true,
		'is_core'    => false
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
		$router->addRoute ( 'feedback_page', new Zend_Controller_Router_Route ( 
			'feedback/page/:id', 
			array (
				'module'     => 'feedback',
				'controller' => 'index',
				'action'     => 'view'
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