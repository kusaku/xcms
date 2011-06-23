<?php
/**
 * 
 * Помошник вида: панель администрирования
 * 
 * @category   Xcms
 * @package    Admin
 * @subpackage View_Helper
 * @version    $Id: PanelAdmin.php 237 2010-07-02 10:52:00Z igor $
 */

class Admin_View_Helper_PanelAdmin extends Zend_View_Helper_Abstract {
	
	public function panelAdmin() {
		$output = ' <div id="site_link"><a href="/" target="blank">'.$_SERVER['HTTP_HOST'].'</a></div>';
		$output .= '<div id="panel"><span>' . $this->view->username;
		$output .= '</span> | <a href="' . $this->view->url( array( 'controller'=>'auth', 'action'=>'logout' ) ) . '">выйти</a></div>';
		return $output;
	}
}