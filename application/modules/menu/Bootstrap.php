<?php
/**
 * 
 * Bootstrap модуля Menu
 *
 * @category   Xcms
 * @package    Menu
 * @version    $Id $
 */

class Menu_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		/*'title'      => 'Меню',
		'type'       => 'tree',
		'controller' => 'menu',
		'types'      => array(
			array(
				'element' => 'menuset',
				'actions' => array(
					'delete' => 'Удалить меню',
					'edit'   => 'Редактировать название блока меню'      
				)
			),	
		),
		'dialog'     => true,
		'addtoroot'  => true,
                'is_core' => true*/
            'title'      => 'Меню',
            'controller' => 'menu',
            'layout' => array(
                    'type' => 'pane',
                    'panes' => array(
                        array(
                            'element' => 'menuset',
                            /*'actions'  => array(
                                    'edit' => 'Редактировать',
                                    'delete' => 'Удалить'
                            ),*/
                            'addtoroot' => array(
                                    'title' => 'Создать меню'
                            )
                        ),
                    )
		),
            'widjet' => 'tree',
                'actions'  => array(
                    'menuset'=>array(
                            'edit' => 'Редактировать',
                            'delete' => 'Удалить',
                    ),
            ),
            'viewform' => 'dialog',
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
				'module' => $name,
				'controller' => 'back'
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