<?php
/**
 * Реестр системы с хранением в БД
 *
 * @category   Xcms
 * @package    Model
 * @version    $Id: Registry.php 231 2010-06-24 13:56:27Z renat $
 * 
 * @uses Model_DbTable_Registry
 * @uses Main
 */

final class Model_Registry extends Zend_Registry {

    /**
     * Режимы установки данных в реестр
     */
    const DATA_DELETE 	= 0;
    const DATA_ADD 		= 1;
    const DATA_UPDATE 	= 2;
	
	/**
	 * Интерфейс доступа к таблице данных реестра
	 * @var array Zend_Db_Table_Abstract
	 */
	private static $_table;
	
	/**
	 * Флаг "все данные загружены"
	 * @var bool
	 */
	private static $_loaded = false;
	
	/**
	 * Массив ключей измененных элем. реестра
	 * @var array ключ=>режим (добавление или изменение)
	 */
	private static $_modified = array();
	
	/**
	 * В конце сохраняет все измененные данные в БД 
	 * @return void
	 */
	public function __destruct() {
		// TODO ...не логируется в FirePHP т.к. срабатывает после вывода
		self::commit();
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице реестра
	 * @return Model_DbTable_Registry
	 */
	protected function getDbTable() {
		if ( !isset( self::$_table ) ) {
			self::$_table = new Model_DbTable_Registry();
		}
		return self::$_table;
	}
	
	/**
	 * Геттер, предварительно загружает значения из БД
	 * @param string $index идентификатор
	 * @return mixed|null
	 */
	public static function get( $index ) {
		$instance = self::getInstance();
		$instance->loadData();
		if ( ! $instance->offsetExists( $index ) ) {
			return null;
		}
        return $instance->offsetGet( $index );
	}
	
	/**
	 * Устанавливает новую переменную в реестр
	 * @param string $index идентификатор
	 * @param mixed $value переменная или объект
	 * @return void
	 */
	public static function add( $index, $value ) {
		parent::set ( $index, $value );
		self::$_modified[ $index ] = self::DATA_ADD;
	}
	
	/**
	 * Устанавливает новое значение в реестр
	 * @param string $index идентификатор
	 * @param mixed $value переменная или объект
	 * @return void
	 */
	public static function update( $index, $value ) {
		parent::set ( $index, $value );
		self::$_modified[ $index ] = self::DATA_UPDATE;
	}
	
	/**
	 * Устанавливает NULL, данные из БД удаляются при следующем commit
	 * @param $index
	 * @return void
	 */
	public static function delete( $index ) {
		parent::set ( $index, NULL );
		self::$_modified[ $index ] = self::DATA_DELETE;
	}
	
	/**
	 * Загружает данные из БД, если они не загружены
	 * @return void
	 */
	public static function loadData() {
		if ( ! self::$_loaded ) {
			$rows = self::getDbTable ()->fetchAll ();
			foreach ( $rows as $row ) {
				// установка загруженных из БД значений
				$val = json_decode( $row->val );
				if ( $val !== false ) {
					parent::set( $row->var, $val );
				} else {
					//throw new Model_Exception("Ошибка при чтении опции '{$row->var}'");
				}
			}
			self::$_loaded = true;
		}
	}
	
	/**
	 * Сохраняет изменения в БД
	 * @return Model_Registry $this
	 */
	public static function commit() {
		$db = self::getDbTable ()->getAdapter ()->beginTransaction ();
		try {
			foreach ( self::$_modified as $var=>$mode ) {
				$value = array( 'val'=>json_encode( self::get($var) ) );
				$where = $db->quoteInto( 'var = ?', $var );
				if ( $mode === self::DATA_UPDATE ) {
					self::getDbTable()->update( $value, $where );
				} elseif ( $mode === self::DATA_ADD ) {
					$value += array( 'var'=>$var );
					self::getDbTable()->insert( $value, $where );
				} elseif ( $mode === self::DATA_DELETE ) {
					self::getDbTable()->delete( $where );
				}
			}
			$db->commit ();
		} catch ( Exception $e ) {
			$db->rollBack ();
			throw new Model_Exception( $e );
		}
	}
}