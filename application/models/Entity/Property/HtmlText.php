<?php
/**
 *
 * Свойство - HTML-текст
 *
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: HtmlText.php 531 2010-10-19 12:24:44Z kifirch $
 *
 * @FIXME поле сохраняется даже без внесения изменений
 */

class Model_Entity_Property_HtmlText extends Model_Entity_Property_Text {

	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	public function getFormElement() {
		return parent::getFormElement()
			->setAttrib( 'class', 'text ' . $this->getTypeName() )
			->setAttrib( 'rows', 25 )
			/*->addFilter( 'StripTags', array( array(
            	'allowTags' => array('p','br','strong','em','u','h1','h2','h3','h4','h5','h6','img','a'),
            	'allowAttribs' => array('style', 'title')
        	)))*/
			//->addFilter( 'HtmlEntities' )
		;
	}
}