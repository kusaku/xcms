<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ObjRel
 *
 * @author aleksey.f
 */
class Model_Entity_Property_ObjRel extends Model_Entity_Property_Select {
    //put your code here
    /**
	 * Устанавливает значение свойства
	 * @param string $value
	 * @return Model_Entity_Property_Integer $this
	 */
	/*public function setValue($value) {
		if ( $value != $this->getValue() ) {
			$this->val_rel_obj = (int) $value;
		}
		return $this;
	}*/
	
	/**
	 * Возвращает значение свойства
	 * @return string
	 */
	/*public function getValue() {
            $object = Model_Collection_Objects::getInstance()->getEntity($this->val_rel_obj);
            return (int) $this->val_rel_obj;
            //return $object->id;
	}
	*/
	/**
	 * Возвращает элемент формы для свойства
	 * @return Zend_Form_Element
	 */
	/*public function getFormElement() {
		$field = $this->getField();
                $arr = Model_Collection_Objects::getInstance()->getGuideObjects($field->id_guide);
                $options = array();
                foreach($arr as $obj) {
                    $options[$obj->id] = $obj->title; 
                }
                $element = new Zend_Form_Element_Select( $field->name );
                $element->setLabel( $field->title )
                                ->setDescription( $field->tip )
                                ->setRequired( $field->is_required )
                                ->setAttrib( 'class', $this->getTypeName() )
                                ->clearDecorators()
                                ->addDecorator( 'Label', array('nameimg' => 'ico_help.gif') )
                                ->addDecorator( 'ViewHelper' )
                                ->addDecorator( 'Errors' )
                                ->addDecorator( 'HtmlTag', array( 'class' => 'halfwidth' ) )
                                ->setOptions($options);
                                //->addFilter( 'Int' );
                if ( ! $this->isVirtual() ) {
                        $element->setValue( $this->getValue() );
                }
		return $element;
	}*/
	
	/**
	 * Сохраняет значение свойства, если оно изменилось
	 * @return Model_Entity_Property_Integer $this
	 */
	/*public function commit() {
		if ( !$this->isVirtual() and array_key_exists( 'val_int', $this->_modifiedFields ) ) {
			$this->save();
		}
		return $this;
	}*/
}

?>
