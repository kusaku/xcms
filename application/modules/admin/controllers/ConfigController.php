<?php
/**
 * 
 * "Асинхронный" контроллер для управления настройками
 * 
 * @category   Xcms
 * @package    Admin
 * @subpackage Controller
 * @version    $Id: $
 */

class Admin_ConfigController extends Xcms_Controller_Back {
	
	/**
	 * Установленные модули
	 * @return void
	 */
	public function editAction() {
		$form = new Admin_Form_Config_Edit();
		$data = array();
		$request = $this->getRequest();
		if ( $request->isPost() ) {
			if ( $form->isValid( $request->getPost() ) ) {
				// сохраняем изменения
				$reg = Zend_Registry::getInstance();
				$values = $form->getValues();
				foreach ( $values as $key=>$value ) {
				// Временное решение для Robots.txt
					$robotsFile = APPLICATION_PATH . '/../public/robots.txt';
					if( $key == 'robots_text' ){
						if ( file_exists( $robotsFile ) ){
							file_put_contents( $robotsFile, $value);
						}else{
							$frobots = fopen($robotsFile, 'w');
							fclose( $frobots );
							file_put_contents( $robotsFile, $value);
						}
					}
					if ( $reg->isRegistered( $key ) ) {
						if ( $reg->get( $key ) != $value ) {
							$reg->update( $key, $value );
						}
					} else {
						$reg->add( $key, $value );
					}
				}
				$reg->commit();
				// очищаем кеш
				$cache = Model_Abstract_Collection::getCache();
				$cache->clean(
					Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
					array( 'Navigation' )
				);
			}
		}
		$data['form'] = $form->render();
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
}

?>