<?php
/**
 * 
 * Bootstrap модуля Catalog
 *
 * @category   Xcms
 * @package    Catalog
 * @version    $Id:
 */

class Guides_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title' => 'Справочн.',
		'controller' => 'guides',
		'layout' => array(
                    'type' => 'pane',
                    'panes' => array(
                        array(
                            'element' => 'guide'
                        ),
                        array(
                            'element' => 'item',
                        ),
                    )
		),
		'widjet' => 'tree',
                'actions'  => array(
                    'guide'=>array(
                            'newitem'    => 'Создать элемент',
                            'delete' => 'Удалить',
                    ),
                    'item'=>array(
                        'edit'=>'Редактировать',
                        'delete'=>'Удалить'
                        )
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