<?php
/**
 * 
 * Объект
 * 
 * Данная модель содержит костыль для модуля feedback и включена в архив с модулем.
 * !!!!! В случае редактирования, не забыть заменить ее в архиве.
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: Object.php 629 2011-02-09 10:18:59Z kifirch $
 */

class Model_Entity_Object extends Model_Abstract_Entity {
	
	/**
	 * Флаг "все свойства загружены"
	 * @var bool
	 */
	protected $_loaded = false;
	
	/**
	 * Тип объекта
	 * @var Model_Entity_ObjectType
	 */
	protected $_type;
	
	/**
	 * Массив идентификаторов свойств объекта объединенных в группы
	 * @var array
	 */
	protected $_groups;
	
	/**
	 * Массив всех свойств объекта
	 * @var array Model_Entity_Property
	 */
	protected $_properties = array();
	
	/**
	 * Магический метод используемый при приведении объекта к строке
	 * @return string
	 */
	public function __toString() {
		return (string) $this->title;
	}

        /**
         * Магический метод используемый при сериализации
         * @return array
         */
        public function __sleep() {
            return array( '_tableClass', '_primary', '_data', '_cleanData', '_readOnly' ,'_modifiedFields', '_loaded', '_groups', '_properties' );
        }
	
	/**
	 * Возвращает, загружены ли свойства объекта
	 * @return bool
	 */
	public function isLoaded() {
		return $this->_loaded;
	}
	
	/**
	 * Возвращает тип
	 * @return Model_Entity_ObjectType тип объекта
	 */
	public function getType() {
		if ( !isset( $this->_type ) ) {
			$this->_type = Model_Collection_ObjectTypes::getInstance()
				->getEntity( $this->id_type );
		}
		return $this->_type;
	}
	
	/**
	 * Изменяет тип объекта. Перезагружает свойства, если необходимо
	 * @param int $type_id идентификатор типа объекта
	 * @return Model_Entity_ObjectType тип объекта
	 */
	public function setType( $type_id ) {
		if ( $this->id_type != $type_id ) {
			$this->id_type = $type_id;
			$this->_type = Model_Collection_ObjectTypes::getInstance()
				->getEntity( $type_id );
			$this->_loaded = false;
			$this->_groups = null;
			$this->_properties = null;
		}
		return $this->_type;
	}
		
	/**
	 * Проверяет, загружена ли группа свойств с данным идентификатором
	 * @param int $group_id
	 * @return bool
	 */
	public function isPropertyGroupLoaded ( $group_id ) {
		return array_key_exists($group_id, $this->_groups);
	}
	
	/**
	 * Возвращает все группы свойств объекта в массиве массивов идентификаторова полей
	 * @return array
	 */
	public function getPropertyGroups() {
		$this->_loadGroups();
		return $this->_groups;
	}
	
	/**
	 * Возвращает группу свойств по имени
	 * @param string $name
	 * @return Model_Entity_FieldsGroup
	 */
	public function getPropertyGroupByName( $name ) {
		$group_id = $this->getType()->getFieldsGroupIdByName( $name );
		return $this->getPropertyGroupById( $group_id );
	}
	
	/**
	 * Возвращает группу свойств по идентификатору
	 * @param int $group_id
	 * @return Model_Entity_FieldsGroup
	 */
	public function getPropertyGroupById( $group_id ) {
		$this->_loadGroups();
		return $this->getType()->getFieldsGroupById( $group_id );
	}
	
	/**
	 * Проверяет, загружено ли свойство с данным идентификатором поля
	 * @param int $field_id идентификатор поля
	 * @return bool
	 */
	public function isPropertyLoaded ( $field_id ) {
		return array_key_exists($field_id, $this->_properties);	
	}
	
	/**
	 * Возвращает свойство по имени поля
	 * @param string $field_name
	 * @return Model_Entity_Property|null
	 */
	public function getPropertyByName( $field_name ) {
		$this->_loadProperties();
		$field_id = Model_Collection_Fields::getInstance()->getFieldIdByName( $field_name );
		if ( isset( $field_id ) ) {
			return $this->getPropertyById( $field_id );
		} else {
			return null;
		}
	}
	
	/**
	 * Возвращает свойство по идентификатору поля, 
	 * 	создает временное если свойство по заданному id не загружено
	 * Предпологается что все установленные свойства объекта уже загружены
	 * @param int $field_id идентификатор поля
	 * @return Model_Entity_Property|null
	 */
	public function getPropertyById( $field_id ) {
		$this->_loadProperties();
		if ( ! $this->isPropertyLoaded( $field_id ) ) {
			$this->_properties[ $field_id ] = $this->_createProperty( $field_id );
		}
		return $this->_properties[ $field_id ];
	}

	/**
	 * Создает временное свойство (не сохраненное в БД) для поля
	 * @param int $field_id идентификатор поля
	 * @return Model_Entity_Property
	 */
	protected function _createProperty( $field_id ) {
		$property = $this
			->_addProperty( Model_Collection_Objects::getInstance()->getDbContent()
				->createRow( array( 'id_field' => $field_id ) )
		);
		return $property;
	}
	
	/**
	 * Добавляет свойство объекта
	 * @param Model_Entity_Property $property объект базового класса для инициализации
	 * @param bool $stored значение свойства есть в БД
	 * @return Model_Entity_Property объект дочернего класса от Model_Entity_Property
	 */
	protected function _addProperty( $property, $stored = false ) {
		$cname = 'Model_Entity_Property_'.ucfirst( $property->getTypeName() );
		if ( !class_exists( $cname ) ) {
			throw new Model_Exception( "Класс свойства '$cname' не существует");
		}
		$data = $property->toArray();
		$data[ 'id_obj' ] = $this->id;
        $config = array(
        	'table'	=> $property->getTable(),
           	'data' => $data,
           	'readOnly' => false,
           	'stored'   => $stored
        );
        $id = $property->id_field;
		$this->_properties [ $id ] = new $cname( $config );
		return $this->_properties [ $id ];
	}
	
	/**
	 * Возвращает значение свойства по имени поля
	 * @param string $field_name
	 * @return mixed
	 */
	public function getValue( $field_name ) {
		$property = $this->getPropertyByName( $field_name );
		if ( isset( $property ) ) {
			return $property->getValue();
		} else {
			return null;
		}
	}
	
	/**
	 * Устанавливает значение свойства
	 * @param string $field_name
	 * @param mixed $value
	 * @return Model_Entity_Object $this
	 */
	public function setValue( $field_name, $value ) {
		$property = $this->getPropertyByName( $field_name );
		if ( isset( $property ) ) {
			$property->setValue( $value );
		} else {
			throw new Model_Exception ( "Ошибка при присвоении значения свойству '$field_name' " );
		}
		return $this;
	}
	
	/**
	 * Возвращает значеня свойств объекта загруженных в объект,
	 * изначально только свойства с сохраненными в БД значениями
	 * @return array значения свойств: имя_поля => значение
	 */
	public function getValues() {
		$this->_loadProperties();
		$values = array();
		foreach ( $this->_properties as $property ) {
			$values[ $property->getField()->name ] = $property->getValue();
		}
		return $values;
	}
	
	/**
	 * Устанавливает значения свойств объекта из массива
	 * @param array $values массив значений: имя_поля => значение
	 * @return Model_Entity_Object $this
	 */
	public function setValues( $values ) {
		foreach ( $values as $name=>$value ) {
			$property = $this->getPropertyByName( $name );
			if ( isset( $property ) ) {
				$property->setValue( $value );
			}
		}
		return $this;
	}
	
	/**
	 * Загружает группы полей для типа данных объекта
	 * @return Model_Entity_Object $this
	 */
	protected function _loadGroups() {
		if ( ! isset( $this->_groups ) ) {
			$groups = $this->getType()->getFieldGroups();
			$this->_groups = array();
			foreach ( $groups as $group ) {
				if ( $group->is_active ) {
					$fields = $group->getFields();
					foreach ( $fields as $field ) {
						$this->_groups[ $group->id ][] = $field->id;
						//$this->_properties [ $field->id ] = null;
					}
				}
			}
		}
		return $this;
	}
	
	/**
	 * Загружает данные объекта из БД, если они не загружены
	 * @return Model_Entity_Object $this
	 */
	protected function _loadProperties() {
		if ( ! $this->isLoaded() ) {
			$this->_loadGroups();
			if ( ! empty( $this->id ) ) { // новый объект не имеет значений в БД
				$mco = Model_Collection_Objects::getInstance();
				$properties = $this->findDependentRowset( $mco->getDbContent() );
				$this->_properties = array();
				foreach ( $properties as $property ) {
					$this->_addProperty( $property, true );
				}
			}
			$this->_loaded = true;
			/*Model_Abstract_Collection::getCache()
				->save( $this, 'Object'.$this->id, array('Object'.$this->id, 'Objects') );*/
		}
		return $this;
	}
	
	/**
	 * Возвращает форму редактирования объекта
	 * @param bool $disabled OPTIONAL блокировать форму (false)
	 * @param bool $display_groups OPTIONAL группировать поля в группы отображения (false)
	 * @param array $skip OPTIONAL список исключений (имена полей)
	 * @return Zend_Form
	 */
	public function getEditForm( $disabled=false, $display_groups=false, $skip=array() ) {
		$form = new Admin_Form_Edit();
		$this->_loadProperties();
		$disabled = $disabled ? true : null;
		foreach ( $this->_groups as $group_id => $property_ids ) {
			// Если данный тип является дочерним от Обратной Связи, то не отображаем группу полей формы
			$OM = Model_Collection_ElementTypes::getInstance();
			$fbObj = $OM->getModuleElementType('feedback');
			if($fbObj->id !== NULL) {
				$ObjType = $fbObj->getObjectType();
				if(
					$this->getType()->id_parent == $ObjType->id && 
					strstr($this->getPropertyGroupById($group_id)->title, 'FieldGroup')
				) continue;
			}
			
			$names = array();
			// поля
			foreach ( $property_ids as $property_id ) {
				$property = $this->getPropertyById( $property_id );
				if ( empty($skip) or !in_array($property->getField()->name, $skip) ) {
					$form->addElement( $property->getFormElement()->setAttrib('disabled', $disabled) );
					$names[] = $property->getField()->name;
				}
			}
			if ( $display_groups and !empty($names) ) {
				// группа отображения
				$group = $this->getPropertyGroupById( $group_id );
				$form->addDisplayGroup( $names, $group->name, array(
					'description' => $group->title,
					'style' => $group->is_visible ? '' : 'display: none;' 
				) );
				if ( !isset($disabled) ) {
					$form->addDisplayGroupButtons( $group->name, ($this->id ? 'edit' : 'add' ) );
				}
			}
		}
		return $form;
	}
	
	/**
	 * Очищает кеш
	 * @return void
	 */
	public function removeCache() {
		$cache = Model_Abstract_Collection::getCache();
		$tags = array('ObjectsAll', 'Object'.$this->id);
		$cache->clean(
			Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
			$tags
		);
	}
	
	/**
	 * Сохранить в базу созданный объект и изменения значений всех его свойств
	 * @todo использование транзакций и логирования
	 * @return Model_Entity_Object $this
	 */
	public function commit() {
		$etype = $this->getType()->getElementType();
                if ($etype) {
                    if ( ! $etype->isActionAllowed( Main::getCurrentUserRole(), 'edit' ) ) {
                            throw new Model_Exception( "Нет прав на редактирование типа данных '".$etype->module."_".$etype->controller."'" );
                    }
                }
		$this->removeCache();
		if ( !empty( $this->_modifiedFields ) ) {
			$this->save();
		}
		foreach ( $this->_properties as $property ) {
			//$this->_properties
			if ( $property->id_obj == 0 ) {
				// Если объект новый, то у его свойств id_obj == 0
				$property->id_obj = $this->id;
			}
			$property->commit();
		}
		return $this;
	}
}