<?php
/**
 * 
 * Помошник вида: ссылка на фабрику
 * 
 * @category   Xcms
 * @package    Xcms_View
 * @subpackage Helper
 * @version    $Id: FabricaLink.php 238 2010-07-02 11:43:40Z renat $
 */

class Zend_View_Helper_FabricaLink extends Zend_View_Helper_Abstract {

	/**
	 * На главной возвращает строку переданную в параметре, иначе - пустую строку 
	 * @param string $output
	 * @return string
	 */
	public function fabricaLink( $output='' ) {
		if ( empty($this->view->element->default) ) {
			$output='';
		}
		return $output;
	}
}