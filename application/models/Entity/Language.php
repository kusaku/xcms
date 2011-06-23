<?php
/**
 * 
 * Язык
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: Language.php 183 2010-05-12 08:36:48Z renat $
 */

class Model_Entity_Language extends Model_Abstract_Entity {
	
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
	}
}