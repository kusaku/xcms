<?php
/**
 * Upload декоратор для загрузки файлов
 *
 * @category   Xcms
 * @package    Xcms_Form
 * @subpackage Decorator
 * @version    $Id: Upload.php 99 2010-01-25 14:03:52Z renat $
 */

class Xcms_Form_Decorator_Upload extends Zend_Form_Decorator_Abstract {
	
	/**
	 * Создает ссылку-кнопку для загрузки файлов
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
		$separator = $this->getSeparator ();
		$placement = $this->getPlacement ();
		$options = $this->getOptions ();
		
		require_once 'Zend/Form/Decorator/HtmlTag.php';
		$options += array (
			'tag' => 'button', 
			'type' => 'button', 
			'id' => $this->getElement ()->getName () . '-upload' 
		);
		$decorator = new Zend_Form_Decorator_HtmlTag ( $options );
		$button = $decorator->render ( 'Загрузить...' );
		
		switch ($placement) {
			case self::APPEND :
				return $content . $separator . $button;
			case self::PREPEND :
				return $button . $separator . $content;
		}
	}
}