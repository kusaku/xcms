<?php
/**
 * 
 * Свойство - шаблон вида (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id:
 */

class Model_Entity_Property_TemplateView extends Model_Entity_Property_Select {
	
	/**
	 * Устанавливает значение свойства
	 * @param string $value
	 * @return Model_Entity_Property_Select $this
	 */
	public function setValue($value) {
            static $old_value;
            if( !isset($old_value) ) $old_value = $this->getValue();
            if ( $value != $this->getValue() ) {
                    $this->val_varchar =  $value;
            }
            if($this->isInheritable()) {
                $obj = $this->getObject();
            }
            return $this;
	}
	
	/**
	 * Возвращает значение свойства
	 * @return string
	 */
	public function getValue() {
		return  $this->val_varchar;
	}
	
	/**
	 * Возвращает массив возможных значений
	 * @return array value=>title
	 */
	protected function getOptions() {
		$module = $this->getObject()->getType()->getElementType()->getModule();
		$ops = $this->list_directory( realpath( APPLICATION_PATH . '/../templates/scripts/'.$module ) );
		return  array('По умолчанию')+$ops;
	}
	
	private function list_directory( $dir ){
   		$file_list = array();
   		$dh = opendir($dir);
   		if ( $dh ){
      		while (($file = readdir($dh)) !== false){
          		if ($file !== '.' AND $file !== '..'){
             		$current_file = "{$dir}/{$file}";
             		if (is_file($current_file)){
             			$file_list[$file] = $file; 
             		}
          		}
       		}
   		}
   		return $file_list;
	}
	
	/**
	 * Сохраняет значение свойства, если оно изменилось
	 * @return Model_Entity_Property_Select $this
	 */
	public function commit() {
		if ( $this->isVirtual() and array_key_exists( 'val_varchar', $this->_modifiedFields ) ) {
			$this->save();
		}
		return $this;
	}
}