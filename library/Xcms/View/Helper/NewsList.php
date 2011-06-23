<?php
/**
 * 
 * Помошник вида: новости
 * 
 * @category   Xcms
 * @package    Xcms_View
 * @subpackage Helper
 * @version    $Id: NewsList.php 238 2010-07-02 11:43:40Z renat $
 */

class Zend_View_Helper_NewsList extends Zend_View_Helper_Abstract {

	/**
	 * Рендерит список новостей по шаблону
	 * @param int $category_id идентификатор элемента-ленты новостей
	 * @param string $partial OPTIONAL шаблон
	 * @param int $limit OPTIONAL максимальное количество выводимых новостей (10)
	 * @return string
	 */
	public function newsList( $category_id, $partial, $limit=10 ) {
		$element = Model_Collection_Elements::getInstance()->getElement ( $category_id );
		if ( ! $element->isReadable() ) return '';
		if ( $element->getType()->getElementClass() != 'news_category' ) return '';
		$type = Model_Collection_ElementTypes::getInstance()
			->getModuleElementType('news', 'item');
		if ( !isset($type) ) return '';
		$children = Model_Collection_Elements::getInstance()
			->getChildren( $category_id, 1, $type->id, false );
		$container = new Zend_Navigation();
		$i = 1;
		foreach ( $children as $k => $have ) {
			$element = Model_Collection_Elements::getInstance()
				->getElement ( $k );
			if ( ! $element->isReadable() ) continue;
			if ( $element->getValue('publish_arch') ) continue;
			$publish_date = date_create( $element->getValue('publish_date_from') );
			$container->addPage( $element->getPage()
				->set('preview', $element->getValue('news_preview') )
				->set('date', $publish_date->format( 'd.m.Y' ) )
			);
			if ( ++$i > $limit ) break;
		}
		$this->view->partial()->setObjectKey('container');
		return $this->view->partial($partial, $container);
	}
}