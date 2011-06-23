<?php
/**
 *
 * Свойство - отображать в меню (виртуальное)
 *
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: Menu.php 547 2010-10-30 09:46:23Z kifirch $
 */

class Model_Entity_Property_Menu extends Model_Entity_Property_Select {

	/**
	 * Устанавливает значение свойства
	 * @param int $value
	 * @param Model_Entity_Element $element объект элемента данного свойства
	 * @return Model_Entity_Property_DefaultPage $this
	 */
	public function setValue( $value, $element=null ) {
            static $old_value;
                if( !isset($old_value) ) $old_value = $this->getValue ($element);
		if ( $value != $this->getValue( $element ) ) {
			$element->id_menu = ( empty($value) || $value == '0' ) ? NULL : (int) $value;
		}
               if($this->isInheritable()) {

                   if( ! is_null($element) ) { // У нерожденного ребенка нет детей!!!
                       try {
                            $childs = $element->getChildren($element->getType()->id);
                       } catch (Exception $e) {
                            return $this;
                       }
                       if( $childs ) {
                           foreach($childs as $elem) {
                              if( $elem->getValue($this->getField()->name) == $old_value  ) {
                                  $elem->setValue($this->getField()->name, $value);
                                  $elem->save();
                              }
                           }
                       }
                   }
                }
		return $this;
	}

	/**
	 * Возвращает значение свойства
	 * @param Model_Entity_Element $element объект элемента данного свойства
	 * @return int
	 */
	public function getValue( $element=null ) {
		if ( ! $element instanceof Model_Entity_Element ) {
			throw new Model_Exception ( self::INVALID_WRAPPER );
		}
                /*if( $this->isInheritable() ) {
                    return empty($element->id_menu) ? $element->getParent()->id_menu : $element->id_menu;
                }*/
		return $element->id_menu;
	}
}