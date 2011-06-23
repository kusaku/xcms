<?php
/**
 * 
 * "Асинхронный" контроллер backend-а модуля корзины
 * 
 * @category   Xcms
 * @package    Content
 * @subpackage Controller
 * @version    $Id: $
 */

class Trash_BackController extends Xcms_Controller_Back {
	
	/**
	 * Элементы в корзине
	 * @return void
	 */
	public function getAction() {
		$id = ( int ) $this->getRequest ()->getParam ( 'element' );
		
		$bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
	    $options = $bootstraps['trash']->getModuleOptions();
	    $actions = $options['actions'];
		
		$mce = Model_Collection_Elements::getInstance ();
		if ( empty($id) ) {
			$children = $mce->getDeleted( false );
		} /*else {
			$children = $mce->getChildren( $id, 2 );
		}*/
		$data = array();
		foreach ( $children as $k => $have ) {
			$element = $mce->getEntity ( $k );
			$elementClass = $element->getType()->getElementClass();
			if ( ! $element->isWritable() ) continue;
			$data[] = array (
				'id' => $element->id,
				'title' => $element->getObject()->title,
				'expandable' => ! empty ( $have ),
				'elementClass' => $elementClass,
				'controller' => 'trash',
				'element' => 'element',
				'actions'=>$actions['element'],
				'is_locked' => ( !$element->is_deleted or !empty($id) )
			);
		}
		// Записываем в тело ответа данные в формате JSON,
		// заголовки ответа устанавливаются плагином (см. Zend_View_Helper_Json)
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	/**
	 * Восстановление элемента с заданным id
	 * @return void
	 * @throws Exception если элемент удалить не удалось (не в production)
	 */
	public function editAction() {
		$element_id = ( int ) $this->getRequest()->getParam( 'element' );
		$success = Model_Collection_Elements::getInstance()
			->restoreElement ( $element_id );
		if (! $success and (APPLICATION_ENV != 'production'))
			throw new Exception ( 'Ошибка при восстановлении элемента' );
		$total = count( Model_Collection_Elements::getInstance()->getDeleted() );
		$this->getResponse()->setBody( $total );
	}

        public function deleteAction() {
		$element_id = ( int ) $this->getRequest()->getParam( 'element' );
		$success = Model_Collection_Elements::getInstance()
			->delEntity( $element_id );
		if (! $success and (APPLICATION_ENV != 'production'))
			throw new Exception ( 'Ошибка при удалении элемента' );
                
		$total = count( Model_Collection_Elements::getInstance()->getDeleted() );
		$this->getResponse()->setBody( $total );
	}
}