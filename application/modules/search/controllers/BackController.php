<?php
/**
 * Description of BackController
 *
 * @author aleksey.f
 */
class Search_BackController extends Xcms_Controller_Back {
	
	public function getAction() {
    	$data = array(
			'text' => 
				'<div id="main">Модуль "Поиск" позволяет осуществлять общий поиск по всем страницам сайта.<br/><br/>Для его активации поставьте соответствующую галочку в настройках модуля.</div>' 
		);
		$this->getResponse()->setBody( $this->view->json( $data ) );
    }

}