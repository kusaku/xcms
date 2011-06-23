<?php
/**
 * 
 * Свойство - шаблон блока (виртуальное)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity_Property
 * @version    $Id: Block.php 2010-08-11 11:02:40Z alex $
 */

class Model_Entity_Property_Block extends Model_Entity_Property_Select {
	
	/**
	 * Устанавливает значение свойства
	 * @param int $value
	 * @param Model_Entity_Element $element объект элемента данного свойства
	 * @return Model_Entity_Property_Block $this
	 */
	public function setValue( $value, $element=null ) {
		if ( $value != $this->getValue( $element ) ) {
			$element->id_tpl = empty($value) ? null : (int) $value;
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
		return $element->id_tpl;
	}
	
	/**
	 * Возвращает массив возможных значений
	 * @return array value=>title
	 */
	protected function getOptions() {
		//$lang_id = Main::getCurrentLanguage()->id;
		$mct = Model_Collection_Blocks::getInstance();
		$rows = $mct->getDbTemplates()->fetchAll(
			$mct->getDbTemplates()->select()
				//->where( 'id_lang = ?', $lang_id )
				//->where( 'filename != ?', 'default' ) // "системный" шаблон
		);
		$ops = array();
		foreach ( $rows as $row ) {
			$ops[ $row->id ] = $mct->addEntity( $row );
		}
		return array( '' ) + $ops;
	}
}