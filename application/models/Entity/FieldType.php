<?php
/**
 * 
 * Тип поля
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: FieldType.php 183 2010-05-12 08:36:48Z renat $
 */

class Model_Entity_FieldType extends Model_Abstract_Entity {
	
	/**
	 * Магический метод используемый при приведении объекта к строке
	 * @return string
	 */
	public function __toString() {
		return (string) $this->title;
	}
	
	/**
	 * Очищает кеш
	 * @return void
	 */
	public function removeCache() {
		$cache = Model_Abstract_Collection::getCache();
		$tags = array('FieldTypesAll', 'FieldType'.$this->id);
		$cache->clean(
			Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
			$tags
		);
	}
}