<?php
/**
 * 
 * Коллекция типов элементов дерева
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Collection
 * @version    $Id: ElementTypes.php 623 2011-01-18 12:48:46Z kifirch $
 */

class Model_Collection_ElementTypes extends Model_Abstract_Collection {
			
	/**
	 * Конструктор коллекции
	 * @return void
	 */
	protected function __construct() {
		$this->setEntName ( 'ElementType' );
	}
	
	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_ElementTypes экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbElementTypes() {
		return $this->getDbTable( 'Model_DbTable_ElementTypes' );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных прав доступа
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbPermissionsModules() {
		return $this->getDbTable( 'Model_DbTable_PermissionsModules' );
	}
	
	/**
	 * Возвращает тип_элемента для пары модуль-контроллер
	 * @param string $module модуль
	 * @param string $controller OPTIONAL контроллер модуля
	 * @return Model_Entity_ElementType|null
	 */
	public function getModuleElementType( $module, $controller = '',$action = 'view' ) {
		$table = $this->getDbElementTypes();
		$etype = $table->fetchRow( $table->select()
			->where( 'module = ?', $module )
			->where( 'controller = ?', $controller )
                        ->where( 'action = ?', $action )
		);
		if ( isset( $etype ) ) {
			return $this->addEntity( $etype );
		} else {
			return null;
		}
	}
	
	/**
	 * Возвращает ресурс типа_элемента для пары модуль-контроллер
	 * @param string $module модуль
	 * @param string $controller OPTIONAL контроллер модуля
	 * @return Zend_Acl_Resource|null
	 */
	public function getAclResource( $module, $controller = '', $action = 'view' ) {
		$etype = $this->getModuleElementType( $module, $controller, $action );
		if ( isset( $etype ) ) {
			return $etype->getAclResource();
		} else {
			return null;
		}
	}
	
	/**
	 * Возвращает список типов элементов
	 * @return array массив идентификатор_объекта=>объект
	 */
	public function getPublic() {
		$table = $this->getDbElementTypes();
		$rows = $table->fetchAll( $table->select()
			->where( 'LENGTH(title) > 0' ) // != NULL, совместимость с sqlite
		);
		$tps = array();
		foreach ( $rows as $row ) {
			$tps[ $row->id ] = $this->addEntity( $row );
		}
		return $tps;
	}


        public function getModules() {
            $table = $this->getDbElementTypes();
		$rows = $table->fetchAll( $table->select()
			->where( 'is_public = 1') // != NULL, совместимость с sqlite
		);
		$tps = array();
		foreach ( $rows as $row ) {
			$tps[ $row->id ] = $this->addEntity( $row );
		}
		return $tps;
        }
}