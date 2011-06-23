<?php
/**
 * 
 * Одиночка
 * Реализует шаблон проектирования - "Одиночка"
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Abstract
 * @version    $Id: Singleton.php 164 2010-03-30 07:26:41Z igor $
 */

abstract class Model_Abstract_Singleton {
	private static $instances = Array ();
	
	/**
	 * Конструктор, требует реализации в дочернем неабстрактном классе
	 */
	abstract protected function __construct();
	
	/**
	 * Получение экземпляра класса, необходимо перегрузить в дочернем классе
	 * @example parent::getInstance(__CLASS__)
	 * @param String имя класса
	 * @return Model_Abstract_Singleton экземпляр класса
	 */
	public static function getInstance($c) {
		if (! isset ( self::$instances [$c] )) {
			self::$instances [$c] = new $c ( );
		}
		return self::$instances [$c];
	}
	
	/**
	 * Запрет копирования
	 */
	public function __clone() {
		throw new Model_Exception ( "Копирование запрещено" );
	}

}