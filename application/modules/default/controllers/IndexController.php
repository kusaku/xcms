<?php
/**
 * 
 * Контроллер по-умолчанию
 * 
 * @category   Xcms
 * @package    Default
 * @subpackage Controller
 * @version    $Id: IndexController.php 566 2010-11-15 10:01:40Z kifirch $
 */

class IndexController extends Zend_Controller_Action {
	
	/*
	 * Перенаправление на content
	 */
	public function indexAction() {
            $this->_forward( 'view', 'index', 'content' );
	}
}

