<?php
/**
 * 
 * Bootstrap модуля Templates
 *
 * @category   Xcms
 * @package    Templates
 * @version    $Id: Bootstrap.php 392 2010-09-16 11:46:24Z igor $
 */

class Templates_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Шаблоны',
		'type'       => 'tree',
		'controller' => 'templates',
		'types'      => array(
			array(
				'element' => 'template',

			)	
		),
                'layout'=> array(
                    'type'=> 'tabs',
                    'panes'=> array(
                        array(
                            'title'=> 'Шаблоны сайта',
                            'element'=> 'site',
                            'addtoroot'=> array(
                                'title' => 'Добавить'
                            ),
                            'widjet' => 'tree'
                        ), 
                        array(
                            'title'=> 'Шаблоны модулей',
                            'element'=> 'view',
                            'widjet' => 'tree'
                        ),
                        array(
                            'title'=> 'Шаблоны блоков',
                            'element'=> 'block',
                            'addtoroot'=> array(
                                'title' => 'Добавить'
                            ),
                            'widjet' => 'tree'
                        )
                    )
                ),
                'actions'  => array(
                    'site'=>array(
                            'edit' => 'Редактировать',
                            'delete' => 'Удалить'
                    ),
                    'view'=>array(
                            'edit' => 'Редактировать'
                    ),
                    'block'=>array(
                            'edit' => 'Редактировать',
                            'delete' => 'Удалить'
                    ),

                ),
                'widjet'=>'tree',
                'viewform' => 'panel',
		'addtoroot' => true,
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