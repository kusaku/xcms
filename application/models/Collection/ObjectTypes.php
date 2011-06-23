<?php
/**
 * 
 * Коллекция типов объектов (типов данных)
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Collection
 * @version    $Id: ObjectTypes.php 268 2010-08-10 13:25:04Z kifirch $
 */

class Model_Collection_ObjectTypes extends Model_Abstract_Collection {
	
	/**
	 * Разрешает кеширование
	 * @var bool
	 */
	protected $_caching = true;
			
	/**
	 * Конструктор коллекции
	 * @return void
	 */
	protected function __construct() {
		$this->setEntName ( 'ObjectType' );
	}
	
	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_ObjectTypes экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbObjectTypes() {
		return $this->getDbTable( 'Model_DbTable_ObjectTypes' );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbFieldGroups() {
		return $this->getDbTable( 'Model_DbTable_FieldGroups' );
	}
	
	/**
	 * Копирует тип данных вместе с группами полей
	 * @param int $id идентификатор копируемого типа
	 * @return Model_Entity_ObjectType|null
	 */
	public function cloneObjectType( $id ) {
		$from_objtype = $this->getEntity( $id );
		if ( ! isset( $from_objtype ) ) {
			throw new Model_Exception( "Тип данных с id='$id' не найден" );
		}
		$data = $from_objtype->toArray();
		$data[ 'is_locked' ] = 0;
		$new_objtype = $this->newEntity( $data );
		if ( $new_objtype ) {
			$new_objtype->copyFieldGroups( $from_objtype );
			$new_objtype->commit();
			return $new_objtype;
		}
		return null;
	}
	
	/**
	 * Создает новый тип данных на основе родительского или из инициализационных данных
	 * @param int|array $data OPTIONAL идентификатор родителя или данные инициализации
	 * @return Model_Entity_ObjectType|null
	 */
	public function createObjectType( $data=null ) {
		if ( ! is_array($data) ) {
			if ( empty($data) ) {
				$data = array(
					'id_element_type' => null,
					'is_guidable' => 1,
					'title' => 'Тип данных'
				);
			} else {
				$parent_id = (int) $data;
				$parent_objtype = $this->getEntity( $parent_id );
				if ( ! isset( $parent_objtype ) ) {
					throw new Model_Exception( "Тип данных с id='$parent_id' не найден" );
				}
				$data = $parent_objtype->toArray();
				$data[ 'id_parent' ] = $parent_id;
				$data[ 'is_locked' ] = 0;
			}
		}
		unset( $data[ 'id' ] );
		$data[ 'title' ] = 'Новый ' . $data[ 'title' ];
		$new_objtype = $this->addEntity( 
			$this->getDbObjectTypes()->createRow( $data ) 
		);
		if ( $new_objtype ) {
			if ( isset( $parent_objtype ) ) {
				$new_objtype->copyFieldGroups( $parent_objtype );
			}
			return $new_objtype;
		}
		return null;
	}
	
	/**
	 * Возвращает все дочерние типы в массиве (вложенные множества), по-умолчанию на 1 уровень вложенности
	 * @param int $id идентификатор типа
	 * @param int $depth OPTIONAL максимальная глубина, null - на всю глубину
	 * @return array идентификатор => массив
	 */
	public function getChildren( $id, $depth=1 ) {
		$table = $this->getDbObjectTypes();
		$res = array(); // результат
		$ids = array( $id ); // рабочие идентификаторы
		$wrk = array( $id => &$res ); // дерево
		while ( !empty( $ids ) and ( !isset($depth) or ($depth > 0) ) ) {
			$select = $table->select();
			if ( $ids[0] == 0 ) {
				$select->where( 'id_parent IS NULL OR id_parent = 0' );
			} else {
				$select->where( 'id_parent IN ( '.implode(',', $ids).' )' );
			}
			$rows = $table->fetchAll( $select );
			$ids = array();
			$tmp = array();
			foreach ( $rows as $row ) {
				$this->addEntity( $row );
				$ids[] = $row->id;
				$wrk[ $row->id_parent ][ $row->id ] = array();
				$tmp[ $row->id ] = &$wrk[ $row->id_parent ][ $row->id ];
			}
			$wrk = $tmp;
			if ( isset($depth) ) $depth--;
		}
		return $res;
	}
	
	/**
	 * Возвращает все дочерние типы списком, по-умолчанию на 1 уровень вложенности
	 * @param int $id идентификатор типа
	 * @param int $depth OPTIONAL максимальная глубина, null - на всю глубину
	 * @return array идентификатор => тип_данных
	 */
	public function getChildrenList( $id, $depth=1 ) {
		$table = $this->getDbObjectTypes();
		$res = array(); // результат
		$ids = array( $id ); // рабочие идентификаторы
		while ( !empty( $ids ) and ( !isset($depth) or ($depth > 0) ) ) {
			$select = $table->select();
			if ( $ids[0] == 0 ) {
				$select->where( 'id_parent IS NULL OR id_parent = 0' );
			} else {
				$select->where( 'id_parent IN ( '.implode(',', $ids).' )' );
			}
			$rows = $table->fetchAll( $select );
			$ids = array();
			foreach ( $rows as $row ) {
				$this->addEntity( $row );
				$ids[] = $row->id;
				$res[ $row->id ] = $row;
			}
			if ( isset($depth) ) $depth--;
		}
		return $res;
	}
	
	/**
	 * Возвращает все справочники
	 * @return array идентификатор => тип_данных
	 */
	public function getGuides() {
		$table = $this->getDbObjectTypes();
		$res = array(); // результат
		$rows = $table->fetchAll( $table->select()
			->where( 'is_guidable = 1' ) 
		);
		foreach ( $rows as $row ) {
			$this->addEntity( $row );
			$res[ $row->id ] = $row;
		}
		return $res;
	}

	/**
	 * Возвращает !все справочники
	 * @return array идентификатор => тип_данных
	 */
	public function getGuidesGuides() {
		$et = Model_Collection_ElementTypes::getInstance()->getModuleElementType('guides', 'back');
		$et_id = $et->id;
		$table = $this->getDbObjectTypes();
		$res = array(); // результат
		$rows = $table->fetchAll( $table->select()
			->where( 'is_guidable = 1' )
			->where( 'id_element_type = ' . $et_id )
		);
		foreach ( $rows as $row ) {
			$this->addEntity( $row );
			$res[ $row->id ] = $row;
		}
		return $res;
	}
}