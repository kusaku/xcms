<?php
 /**
 * 
 * Объекты информационной модели
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Collection
 * @version    $Id: Objects.php 183 2010-05-12 08:36:48Z renat $
 */

class Model_Collection_Objects extends Model_Abstract_Collection {
	
	/**
	 * Разрешает кеширование
	 * @var bool
	 */
	protected $_caching = false;
			
	/**
	 * Конструктор коллекции
	 * @return void
	 */
	protected function __construct() {
		$this->setEntName ( 'Object' );
	}
	
	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_Objects экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}
		
	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbObjects() {
		return $this->getDbTable( 'Model_DbTable_Objects' );
	}
		
	/**
	 * Возвращает интерфейс доступа к таблице данных значений
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbContent() {
		return $this->getDbTable( 'Model_DbTable_Content' );
	}
	
	/**
	 * Создает новый объект данных и добавляет его в коллекцию (доступен по id=0)
	 * @param $data OPTIONAL данные инициализации
	 * @return Model_Entity_Object
	 */
	public function createObject( $data=array() ) {
		if ( !isset($data['id_type']) or empty($data['id_type']) ) {
			throw new Model_Exception( 'Не указан тип данных' );
		}
		unset( $data ['id'] );
		$new_object = $this->addEntity( $this->getDbObjects()->createRow( $data ) );
		return $new_object;
	}
	
	/**
	 * Возвращает список всех объектов заданного типа
	 * @param int $type_id идентификатор типа объекта
	 * @param string $order колонка сортировки
	 * @return array массив идентификатор_объекта=>объект
	 */
	public function getObjectsByType( $type_id, $order='title' ) {
		$table = $this->getDbObjects();
		$select = $table->select();
		$select	->where( 'id_type = ?', (int) $type_id )
				->order( $order );
		$rows = $table->fetchAll( $select );
		$objs = array();
		foreach ( $rows as $row ) {
			$objs[ $row->id ] = $this->addEntity( $row );
		}
		return $objs;
	}

	/**
	 * Возвращает список возможных значений для справочника
	 * @param $guide_id идентификатор справочника (тип объекта)
	 * @param string $order колонка сортировки
	 * @return array массив идентификатор_объекта=>объект
	 */
	public function getGuideObjects( $guide_id, $order='title' ) {
		return $this->getObjectsByType( $guide_id, $order );
	}

	/**
	 * Копирует объект дерева вместе с его свойствами
	 * @param int $id идентификатор объекта
	 * @return Model_Entity_Object|null
	 * @throws Model_Exception если объект не существует
	 */
	public function cloneObject( $id ) {
		$object = $this->getEntity( $id );
		if ( ! isset( $object ) ) {
			throw new Model_Exception( "Ошибка доступа к объекту с id='$id' " );
		}
		// TODO возможно заменить методом Object::copyProperties( Object ) c одним запросом insert+select
		$new_object = $this->createObject( $object->toArray() );
		if ( $new_object ) {
			$new_object->setValues( $object->getValues() );
			//$new_object->setValue( 'name', 'Копия ' . $object->getValue( 'name' ) );
			$new_object->title = 'Копия ' . $new_object->title;
			$new_object->commit();
			return $new_object;
		}
		return null;
	}
}