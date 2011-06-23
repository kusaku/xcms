<?php
/**
 * 
 * Bootstrap модуля Admin
 *
 * @category   Xcms
 * @package    Admin
 * @version    $Id: Bootstrap.php 394 2010-09-16 11:50:56Z igor $
 */

class Admin_Bootstrap extends Zend_Application_Module_Bootstrap {
	
	/**
	 * Свойства модуля
	 * @var array
	 */
	protected $_moduleOptions = array(
		'title'      => 'Настройки',
		'controller' => 'config',
		'type'       => 'editform',
		'widjet' => 'editform',
		'is_core' => true
	);
	
	/**
	 * Возвращает свойства модуля
	 * @return array
	 */
	public function getModuleOptions() {
		return $this->_moduleOptions;
	}
}