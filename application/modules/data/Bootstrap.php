<?php
/**
 * 
 * Bootstrap модуля Data
 *
 * @category   Xcms
 * @package    Data
 * @version    $Id: Bootstrap.php 394 2010-09-16 11:50:56Z igor $
 */

class Data_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
            'title'      => 'Типы',
            'controller' => 'data',
            'layout' => array(
                'type' => 'otype',
                'panes' => array(
                    array(
                        'element' => 'otype',
                        'addtoroot' => array(
                            'title' => 'Добавить'
                        ),
                        
                    ),
					array(
						'element' => 'group',
					),
					array(
                        'element' => 'field'
                    )
                )
            ),
            'viewform' => 'panel',
            'actions'  => array(
                'otype'=>array(
                    'new'    => 'Создать тип данных',
                    'edit' => 'Редактировать тип данных',
                    'delete' => 'Удалить тип данных'
                ),
				'group'=>array(
					'newfield' => 'Создать элемент',
					'edit'=>'Править'
				),
				'field'=>array(
					'newfield'=>'Новьё',
					'editfield'=>'Отредактировать',
					'deletefield'=>'Снести к.'
				)
            ),
            'widjet' => 'tree',
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