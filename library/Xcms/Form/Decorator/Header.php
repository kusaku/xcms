<?php
/**
 * Декоратор заголовка группы полей формы
 *
 * @category   Xcms
 * @package    Xcms_Form
 * @subpackage Decorator
 * @version    $Id: Header.php 180 2010-04-28 08:40:18Z igor $
 */

class Xcms_Form_Decorator_Header extends Zend_Form_Decorator_Description {
	
	/**
	 * Рендерит заголовок группы полей формы
	 * 
	 * @param  string $content 
	 * @return string
	 */
	public function render($content) {
		$element = $this->getElement ();
		$view = $element->getView ();
		if (null === $view) {
			return $content;
		}
		
		$description = $element->getDescription ();
		$description = trim ( $description );
		
		if (! empty ( $description ) && (null !== ($translator = $element->getTranslator ()))) {
			$description = $translator->translate ( $description );
		}
		
		if (empty ( $description )) {
			return $content;
		}
		
		$separator = $this->getSeparator ();
		$placement = $this->getPlacement ();
		$tag = $this->getTag ();
		$class = $this->getClass ();
		$escape = $this->getEscape ();
		
		$options = $this->getOptions ();
		
		if ($escape) {
			$description = $view->escape ( $description );
		}
		
		if (! empty ( $tag )) {
			require_once 'Zend/Form/Decorator/HtmlTag.php';
			$options ['tag'] = $tag;
			$decorator = new Zend_Form_Decorator_HtmlTag ( $options );
			$description = $decorator->render ( $description );
		}
		
		switch ($placement) {
			case self::PREPEND :
				return $description . $separator . $content;
			case self::APPEND :
			default :
				return $content . $separator . $description;
		}
	}
}