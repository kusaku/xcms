<?php
/**
 * 
 * Помошник вида: ссылка на страницу новостей
 * 
 * @category   Xcms
 * @package    Xcms_View
 * @subpackage Helper
 * @version    $Id:
 */

class Zend_View_Helper_NewsHref extends Zend_View_Helper_Abstract {

	/**
	 * Рендерит ссылку на страницу новостей News
	 * @return string
	 */
	public function newsHref() {
		$href = '';
		$category_id = $this->view->element->id;		
		$category = Model_Collection_Elements::getInstance()->getElement( $category_id );
		if ( !Zend_Registry::getInstance()->get( 'use_urlnames' ) ) {
			$href = 'news/category/'.$category_id;
		}else{
			$href = $category->urlname;
		}
		return $href;
	}
}