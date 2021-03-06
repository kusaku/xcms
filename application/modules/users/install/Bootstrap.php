<?php
/**
 * 
 * Bootstrap модуля Users
 *
 * @category   Xcms
 * @package    Users
 * @version    $Id $
 */

class Users_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Профили',
		'type'       => 'tree_expanded',
		'controller' => 'users',
		'types'      => array(
			array(
				'element' => 'group',
				'actions' => array(
					'edit'   => 'Редактировать группу',
			        'new'    => 'Создать нового пользователя'
				)
			),
			array(
				'element' => 'user',
				'actions' => array(
					'delete' => 'Удалить пользователя',
					'edit'   => 'Редактировать пользователя'
				)
			),	
		),
		'dialog'     => true,
		'addtoroot'  => true,
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
                
                $router->addRoute ( 'users_register', new Zend_Controller_Router_Route (
			'users/register/:id',
			array (
				'module' => 'users',
				'controller' => 'register',
				'action' => 'view'
			),
                        array(
                            'id' => '\d+'
                        )
		) );
                $router->addRoute ( 'users_profile_action', new Zend_Controller_Router_Route (
			'users/profile/:id/:do',
			array (
				'module' => 'users',
				'controller' => 'profile',
				'action' => 'view',
			),
                         array(
                            'id' => '\d+',
                            'do' => '\w+'
                        )
		) );
		$router->addRoute ( 'users_profile', new Zend_Controller_Router_Route (
			'users/profile/:id',
			array (
				'module' => 'users',
				'controller' => 'profile',
				'action' => 'view',
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
		if ( ! Model_Collection_ElementTypes::getInstance()
			->getModuleElementType( 'users', 'group' ) // разрешено ли пользователю работать с группами?
				->isActionAllowed( Main::getCurrentUserRole(), 'edit' ) ) {
			unset($this->_moduleOptions['addtoroot']);	
			unset($this->_moduleOptions['types'][0]['actions']['edit']);
		}
		return $this->_moduleOptions;
	}
}