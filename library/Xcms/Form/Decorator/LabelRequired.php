<?php
/**
 * Label декоратор
 *
 * @category   Xcms
 * @package    Xcms_Form
 * @subpackage Decorator
 * @version    $Id: Label.php 180 2010-04-28 08:40:18Z igor $
 */

class Xcms_Form_Decorator_LabelRequired extends Zend_Form_Decorator_Label {
	
	/**
	 * Создает label с подсказкой
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
		
		$label = $this->getLabel ();
		$description = $element->getDescription ();
		$description = trim ( $description );
		$separator = $this->getSeparator ();
		$placement = $this->getPlacement ();
		$tag = $this->getTag ();
		$id = $this->getId ();
		$class = $this->getClass ();
		$options = $this->getOptions ();
		
		if (empty ( $label ) && empty ( $tag )) {
			return $content;
		}
		
		if (! empty ( $label )) {
			$options ['class'] = $class;
			$label = $view->formLabel ( 
				$element->getFullyQualifiedName (), 
				trim ( $label ), 
				$options 
			);
			//$label = '<label class="'.$class.'"><div>'.$label.'</div></label>';
			if (isset ( $options ['required'] ))
				$label = str_replace ( '</label>', '<span class="b-orange">*</span></label>', $label );
		} else {
			$label = '&nbsp;';
		}
		if (null !== $tag) {
			require_once 'Zend/Form/Decorator/HtmlTag.php';
			$decorator = new Zend_Form_Decorator_HtmlTag ( );
			$decorator->setOptions ( array (
				'tag' => $tag, 
				'id' => $this->getElement ()->getName ()
			) );
			
			$label = $decorator->render ( $label );
		}
		
		switch ($placement) {
			case self::APPEND :
				return $content . $separator . $label;
			case self::PREPEND :
				return $label . $separator . $content;
		}
	}
}