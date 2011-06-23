<?php
/**
 * 
 * "Асинхронный" контроллер модуля
 * 
 * @category   Xcms
 * @package    Feedback
 * @subpackage Controller
 * @version    $Id: BackController.php 238 2010-07-02 11:43:40Z renat $
 */

class Feedback_BackController extends Xcms_Controller_Back {
	
	/**
	 * Получение списка страниц типа "Обратная связь"
	 * @return void
	 */
	public function getAction() {
		$type = Model_Collection_ElementTypes::getInstance()
			->getModuleElementType('feedback');
		if ( isset($type) ) {
			$fb_type_id = $type->id;
		} else {
			throw new Exception( 'Тип данных обратная связь не существует' );
		}
		$mce = Model_Collection_Elements::getInstance ();
		$bootstraps = $this->getInvokeArg('bootstrap')->getResource( 'modules' );
	    $options = $bootstraps['feedback']->getModuleOptions();
	    $actions = $options['actions'];
	    $fb_items = $mce->getElementsByType( $fb_type_id );
	    $data = array();
		foreach ( $fb_items as $k => $items_element ) {
			$item = $mce->getElement( $k );
			$itemClass = $item->getType()->getElementClass();
			if ( ! $item->isReadable() ) continue;
			$data[] = array (
			    'id' => $item->id,
			    'title' => $item->getObject()->title,
			    'expandable' => false,
			    'elementClass' => $itemClass,
			    'controller' => 'feedback',
			    'element' => 'element',
			    'actions'=>$actions['element']
		    );
		}
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	public function editAction() {
		$type = Model_Collection_ElementTypes::getInstance()
			->getModuleElementType('feedback');
		if ( isset($type) ) {
			$fb_type_id = $type->id;
		} else {
			throw new Exception( 'Тип данных обратная связь не существует' );
		}
		$form_id = $this->getRequest()->getParam( 'element' );
		if ( isset ( $form_id ) ) {
			if ($form_id == 'new') {
				$form = Model_Collection_Elements::getInstance()->createElement(0, $fb_type_id);
			} else {
				$form_id = ( int ) $form_id;
				if ($form_id > 0) {
					$form = Model_Collection_Elements::getInstance ()
						->getElement ( $form_id );
				} else {
					if (APPLICATION_ENV != 'production')
						throw new Exception ( 'Неправильный идентификатор элемента' );
				}
			}
			
		}
		if (! isset ( $form )) {
			throw new Exception ( 'Нет формы' );
		}
		$writable = $form->isWritable();
		$editform = $form->getEditForm(!$writable);
		$data = array();
		$request = $this->getRequest();
		if ( $writable and $this->getRequest()->isPost() ) {
			if ( $editform->isValid( $request->getPost() ) ) {
				$form->setValues( $editform->getValues() );
				$form->commit();
				$editform = $form->getEditForm();
				$data = array (
					'id' => $form->id,
					'parent_id' => 0,
					'title' => $form->getObject()->title,
					'elementClass' => $form->getType()->getElementClass(),
					'expandable' => false
				);
				if ( $form_id == 'new' ) {
					$data['expandable'] = false;
					if ( !empty($max) ) {
						$total_pages++;
						if ( $total_pages >= $max )
							$data['createElement'] = false;
						else
							$data['createElement'] = true;
					}
				}
			} else {
				$this->setIsErrors( $form );
			}
		}
		$data ['form'] = $editform->render();
		$this->getResponse()->setBody( $this->view->json( $data ) );
	}
	
	public function newAction() {
		$this->getRequest()->setParam( 'element', 'new' );
		$this->_forward( 'edit' );
	}
	
	public function deleteAction() {
		$form_id = ( int ) $this->getRequest()->getParam( 'element' );
		$success = Model_Collection_Elements::getInstance()
			->delElement ( $form_id );
		if (! $success and (APPLICATION_ENV != 'production'))
			throw new Exception ( 'Ошибка при удалении формы' );
		$total = count( Model_Collection_Elements::getInstance()->getDeleted() );
		$this->getResponse()->setBody( $total );
	}
	
	
}

?>