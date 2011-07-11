<?php
/**
 * 
 * Коллекция элементов дерева
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Collection
 * @version    $Id: Elements.php 623 2011-01-18 12:48:46Z kifirch $
 */

class Model_Collection_Elements extends Model_Abstract_Collection {
	
	/**
	 * Разрешает кеширование
	 * @var bool
	 */
	protected $_caching = true;
	
	/**
	 * Идентификатор элемента по умолчанию
	 * @var int
	 */
	protected $_default;
	
	/**
	 * Конструктор коллекции
	 * @return void
	 */
	protected function __construct() {
		$this->setEntName ( 'Element' );
	}
	
	/**
	 * Получение экземпляра класса
	 * @return Model_Collection_Elements экземпляр класса
	 */
	public static function getInstance() {
		return parent::getInstance ( __CLASS__ );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbElements() {
		return $this->getDbTable( 'Model_DbTable_Elements' );
	}
	
	/**
	 * Возвращает интерфейс доступа к таблице данных прав доступа
	 * @return Zend_Db_Table_Abstract объект интерфейса
	 */
	public function getDbPermissionsElements() {
		return $this->getDbTable( 'Model_DbTable_PermissionsElements' );
	}
	
	/**
	 * Возвращает элемент по умолчанию
	 * @param int $lang_id OPTIONAL идентификатор языка (по-умолчанию - текущий)
	 * @return Model_Entity_Element элемент дерева
	 */
	public function getDefault( $lang_id=null ) {
		if ( ! isset($this->_default) ) {
			if ( ! isset($lang_id) ) {
				$lang_id = Main::getCurrentLanguage()->id;
			}
			$table = $this->getDbElements();
			$element = $table->fetchRow( $table->select()
				->where( 'id_lang = ?', $lang_id )
				->where( 'is_default = ?', 1 )
			);
			if ( !isset($element) ) {
				throw new Model_Exception( "Главная не найдена" );
			}
			$this->addEntity( $element );
		}
		if ( $this->_entities[$this->_default]->is_deleted ) {
			throw new Model_Exception( "Элемент дерева с id='{$this->_default}' удален" );
		}
		return $this->_entities[ $this->_default ];
	}
	
	/**
	 * Устанавливает элемент по умолчанию
	 * @param int $id
	 * @return Model_Collection_Elements $this
	 */
	public function setDefault( $id ) {
		if ( $id != $this->_default ) {
			$new = $this->getEntity( $id );
			if ( isset ( $new ) ) {
				$db = $this->getDbElements()->getAdapter();
				$db->beginTransaction();
				try {
					$old = $this->getDefault();
					$old->is_default = 0;
					$old->save();
					$old->removeCache();
					$new->is_default = 1;
					$new->save();
					$new->removeCache();
					$this->_default = $id;
				} catch (Exception $e) {
					$db->rollBack();
				}
				$db->commit();
			}
		}
		return $this;
	}
	
	/**
	 * Возвращает порядок последнего дочернего элемента или 0, если таковых нет
	 * @param int $parent_id OPTIONAL идентификатор элемента - родителя (по-умолчанию = в корне)
	 * @return int порядок последнего дочернего элемента
	 */
	public function getLastOrd( $parent_id=null ) {
		$table = $this->getDbElements();
		$select = $table->select();
		if ( empty($parent_id) ) {
			$select->where( 'id_parent IS NULL OR id_parent = 0' );
		} else {
			$select->where( 'id_parent = ?', $parent_id );
		}
		$select->order( 'ord DESC' );
		$element = $table->fetchRow( $select );
		if ( isset( $element ) ) {
			return $this->addEntity( $element )->ord;
		} else {
			return 0;
		}
	}
	
	/**
	 * Добавляет элемент в коллекцию
	 * @param Model_Entity_Element $entity
	 * @return Model_Entity_Element
	 */
	public function addEntity( $entity ) {
		if ( $entity->is_default ) {
			$this->_default = $entity->id;
		}
		return $this->_entities [ $entity->id ] = $entity;
	}
	
	/**
	 * Возвращает элемент дерева с указанным id,
	 * если такого нет, он добавляется в коллекцию;
	 * удаленные элементы не возвращаются
	 * @param int $id идентификатор элемента
	 * @return Model_Entity_Element элемент дерева
	 * @throws Model_Exception если элемент не найден или удален
	 */
	public function getElement( $id ) {
		$element = $this->getEntity( $id );
		if ( ! isset( $element ) ) {
			throw new Model_Exception( "Элемент дерева с id='$id' не найден" );
		}
		if ( $element->is_deleted ) {
			throw new Model_Exception( "Элемент дерева с id='$id' удален" );
		}
		return $element;
	}
	
	/**
	 * Копирует элемент и вставляет его в конец
	 * Копирование всех дочерних элементов опционально
	 * @param int $id идентификатор элемента
	 * @param bool $with_subs OPTIONAL копировать всю ветвь (вместе с подэлементами)
	 * @return Model_Entity_Element|null элемент дерева или ничего
	 */
	public function copyElement( $id, $with_subs=false ) {
		return $this->_cloneElement( $id, $with_subs, false );
	}
	
	/**
	 * Копирует элемент + объект данных и и вставляет его в конец
	 * Копирование всех дочерних элементов опционально
	 * @param int $id идентификатор элемента
	 * @param bool $with_subs OPTIONAL копировать всю ветвь (вместе с подэлементами)
	 * @return Model_Entity_Element|null элемент дерева или ничего
	 */
	public function cloneElement( $id, $with_subs=false ) {
		return $this->_cloneElement( $id, $with_subs, true );
	}
	
	/**
	 * Копирует элемент и вставляет его в конец
	 * Может также рекурсивно копировать все дочерние элементы
	 * Опционально копирует объект данных
	 * @todo копирование подэлементов - возможно заменить рекурсию циклом
	 * @todo возможно $with_subs заменить на array|bool $subs чтобы не делать лишний запрос к БД ?
	 * @param int $id идентификатор элемента
	 * @param bool $with_subs OPTIONAL копировать всю ветвь (вместе с подэлементами)
	 * @param bool $with_data OPTIONAL копировать объект данных
	 * @param int $destination_id OPTIONAL идент. элемента - родителя (исп. в рекурсии)
	 * @return Model_Entity_Element|null элемент дерева или ничего
	 * @throws Model_Exception если не удалось скопировать объект данных
	 */
	protected function _cloneElement( $id, $with_subs=false, $with_data=false, $destination_id=null  ) {
		// Копируемый элемент
		$element = $this->getElement( $id );
		$data = $element->toArray();
		if ( $with_data ) {
			// Копирование объекта данных элемента
			$new_object = Model_Collection_Objects::getInstance()
				->cloneObject( $element->getObject()->id );
			if ( ! isset( $new_object ) ) {
				throw new Model_Exception( "Ошибка копирования объекта для элемента с id='$id' " );
			}
			$data[ 'id_obj' ] = $new_object->id;
		}
		if ( isset( $destination_id ) ) {
			// Дочерний
			$data[ 'id_parent' ] = empty($destination_id) ? null : (int) $destination_id;
		} else {
			// Вставка в конец
			$data[ 'ord' ] = intval( $this->getLastOrd( $data[ 'id_parent' ] ) ) + 1;
		}
		$data[ 'urlname' ] .= mktime(); // TODO заменить на инкрементацию индекса
		$this->updatetime = date_create()->format( DATE_ATOM ); // дата создания
		$new_element = $this->newEntity( $data );
		if ( $new_element ) {
			// TODO дублирование прав на элемент?
			if ( $with_subs ) {
				// Копирование дочерних элементов
				$children = $this->getChildren( $id, 2 );
				foreach ( $children as $child_id=>$descendants ) {
					$this->_cloneElement( $child_id, !empty( $descendants ), $with_data, $new_element->id );
				}
			}
			return $new_element;
		}
		return null;
	}
	
	/**
	 * Создание нового элемента дерева + объекта данных
	 * Метод не сохраняет в БД, используйте {@link Model_Entity_Element::commit()}
	 * @param int $parent_id OPTIONAL
	 * @param int $element_type_id OPTIONAL
         * @param int $title OPTIONAL - имя элемента
	 * @return Model_Entity_Element
	 * @todo в качестве входного параметра использовать $data
	 */
	public function createElement( $parent_id=null, $element_type_id=null, $title = 'Новая страница' ) {
		if ( empty($parent_id) ) {
			$parent_id = null;
                        $id_menu = null;
		} else {
			$parent = $this->getElement( $parent_id );
			if ( empty($element_type_id) ) {
                            $element_type_id = $parent->id_type;
                            $object_type_id = $parent->getObject()->id_type;
                            $id_menu = $parent->id_menu;
			} else {
                            $id_menu = null;
                        }
		}
		if ( !isset($object_type_id) ) {
			if ( empty($element_type_id) ) {
				$etype = Model_Collection_ElementTypes::getInstance()->getModuleElementType('content', '');
			} else {
				$etype = Model_Collection_ElementTypes::getInstance()->getEntity( $element_type_id );
			}
			if ( ! isset( $etype ) ) {
				throw new Model_Exception( "Типа элемента не существует" );
			}
			$element_type_id = $etype->id;
			$otype = $etype->getObjectType();
			if ( !isset($otype) ) {
				throw new Model_Exception( "Тип данных не существует" );
			}
			$object_type_id = $otype->id;
		}
		// Создаем объект данных
		$data = array(
			'id_type' => $object_type_id,
			'title' => $title//'Новая страница'
		);
		$new_object = Model_Collection_Objects::getInstance()->createObject( $data );
		if ( ! isset( $new_object ) ) {
			throw new Model_Exception( "Ошибка создания объекта данных для нового элемента" );
		}
		$data = array(
			'id_parent' => $parent_id,
			'id_type'   => $element_type_id,
			'id_obj'    => $new_object->id, // фактически == 0
			'id_lang'   => Main::getCurrentLanguage()->id,
                        //'id_menu'   => $id_menu,
                        'is_active' => true,
			'urlname'	=> mktime(), // TODO заменить на транстлитирацию титла?
			'ord'       => ( intval( $this->getLastOrd( $parent_id ) ) + 1 )
		); // updatetime ставится в Element::commit()
		return $this->addEntity( $this->getDbElements()->createRow( $data ) );
	}
	
	/**
	 * Устанавливает флаг "удален" для элемента и его дочерних элементов
	 * @param int $id идентификатор элемента
	 * @return значение первичного ключа
	 */
	public function delElement( $id ) {
		$element = $this->getElement( $id );
		if((bool)$element->is_default)
			return false;
		$element->is_deleted = 1;
		$table = $this->getDbElements();
		$select = $table->select()
			->where( 'is_deleted = 0' );
		$res = array(); // результат
		$ids = array( $id ); // рабочие идентификаторы
		$wrk = array( $id => &$res ); // дерево
		while ( !empty( $ids ) ) {
			$s = clone $select; // копируем where
			if ( $ids[0] == 0 ) {
				$s->where( 'id_parent IS NULL OR id_parent = 0' );
			} else {
				$s->where( 'id_parent IN ( '.implode(',', $ids).' )' );
			}
			$rows = $table->fetchAll( $s );
			$ids = array();
			$tmp = array();
			foreach ( $rows as $row ) {
				$row->is_deleted = 1;
				$row->commit();
				$ids[] = $row->id;
				$wrk[ $row->id_parent ][ $row->id ] = array();
				$tmp[ $row->id ] = &$wrk[ $row->id_parent ][ $row->id ];
			}
			$wrk = $tmp;
		}
		return $element->commit();
	}
	
	/**
	 * Убирает флаг флаг "удален" для элемента 
	 * @param int $id идентификатор элемента
	 * @return значение первичного ключа
	 */
	public function restoreElement( $id ) {
		$element = $this->getEntity( $id );
		$element->is_deleted = 0;
		if ( !empty($element->id_parent) ) {
			$parent = $this->getEntity($element->id_parent);
			if ( isset($parent) and $parent->is_deleted ) {
				$element->id_parent = NULL;
			}
		}
		return $element->commit();
	}
	
	/**
	 * Перемещает элемент
	 * @param int $id идентификатор элемента
	 * @param int $destination_id куда перенести - идентификатор будущего родителя
	 * @param int $before_id OPTIONAL перед каким элементом поставить (0 - в начало, если не указан - в конец)
	 * @param int $ord_val OPTIONAL позволяет указать значение ORD без всяких расчётов
	 * @return значение первичного ключа
	 */
	public function moveElement( $id, $destination_id, $before_id=null, $ord_val=null ) {
		$element = $this->getElement( $id );
                //$e_ch = (int)@$element->is_child;
		$destination_id = empty($destination_id) ? null : (int) $destination_id;
                /*if($e_ch && empty($destination_id)) {
                    print('Не может существовать без родителя');
                    return false;
                }*/
                /*if( $destination_id != null ) {
                    $ed = $this->getElement($id);
                    $type = $ed->id_type;
                    $ch = $ed->is_child;
                    $class = Model_Collection_ElementTypes::getInstance()->getEntity($type)->getElementClass();
                    if($e_ch && $ch) {
                        print('Не может существовать без родителя');
                        return false;
                    }
                }*/
		$element->id_parent = $destination_id;
		$table = $element->getTable();
		if ( isset( $before_id ) ) {
			$before_id = (int) $before_id;
			if ( $before_id > 0 ) {
				$ord = (int) $this->getEntity( $before_id )->ord;
			} else {
				// В начало
				$ord = 1;
			}	
			$element->ord = $ord;
			// Сдвиг всех
			$table->update( 
				array ( 'ord' => new Zend_Db_Expr( 'ord+1' ) ),
				array (
					'id_parent = '.$destination_id,
					'ord >= '.$ord
				)
			);
		} else
		if ( !isset( $ord_val ) ){
			// В конец
			$element->ord = intval( $this->getLastOrd( $destination_id ) ) + 1;
		}
		else
		{
			$element->ord = $ord_val;
		}
		return $element->save();
	}
	
	/**
	 * Возвращает список всех не удаленных элементов заданного типа
	 * @param int $type_id идентификатор типа элементов
	 * @param string $order OPTIONAL колонка сортировки
	 * @return array массив идентификатор_элемента=>элемент
	 */
	public function getElementsByType( $type_id, $order='ord' ) {
		$table = $this->getDbElements();
		$select = $table->select();
		$select->where( 'id_type = ?', (int) $type_id )
		       //->where( 'is_active = 1' )
		       ->where( 'is_deleted = 0' );
		list($order_col) = explode( ' ', $order );
		if ( in_array( $order_col, $table->info('cols') ) ) {
			$select->order( $order );
		} else {
			// TODO добавить возможность сортировки по доп.полям см. Element::getChildren()
		}
		$rows = $table->fetchAll( $select );
		$items = array();
		foreach ( $rows as $row ) {
			$items[ $row->id ] = $this->addEntity( $row );
		}
		return $items;
	}
	
	/**
	 * Возвращает количество всех элементов заданного типа
	 * @param int $type_id идентификатор типа элемента
	 * @return int
	 */
	public function countElementsByType( $type_id ) {
		$table = $this->getDbElements();
		$select = $table->select();
		$select	->where( 'id_type = ?', (int) $type_id );
		$rows = $table->fetchAll( $select );
		$count = $rows->count();
		return $count;
	}
	
	/**
	 * Возвращает все дочерние элементы дерева по заданную глубину в массиве (вложенные множества)
	 * Элементы добавляются в коллекцию
	 * @param int $id идентификатор элемента
	 * @param int $depth OPTIONAL максимальная глубина, по-умолчанию - на 1 уровень
	 * @param int $type_id OPTIONAL элементы только определенного типа (null)
	 * @param bool $inc_unactive OPTIONAL включить в результаты неактивные элементы (true)
	 * @param bool $inc_active OPTIONAL включить в результаты активные элементы (true)
	 * @return array
	 */
	public function getChildren( $id, $depth=1, $type_id=null, $inc_unactive=true, $inc_active=true ) {
		$table = $this->getDbElements();
		$select = $table->select(); // общие условия where
		if ( ! $inc_unactive ) {
			$select->where( 'is_active = 1' );
		}
		if ( ! $inc_active ) {
			$select->where( 'is_active = 0' );
		}
		if ( isset($type_id) ) {
			$select->where( 'id_type = ?', (int) $type_id );
		}
		$select->where( 'is_deleted = 0' )
		       ->order(array('id_parent','id_type','ord') );
		$res = array(); // результат
		$ids = array( $id ); // рабочие идентификаторы
		$wrk = array( $id => &$res ); // дерево
		while ( ($depth > 0) and !empty( $ids ) ) {
			$s = clone $select; // копируем where
			if ( $ids[0] == 0 ) {
				$s->where( 'id_parent IS NULL OR id_parent = 0' );
			} else {
				$s->where( 'id_parent IN ( '.implode(',', $ids).' )' );
			}
			$rows = $table->fetchAll( $s );
			$ids = array();
			$tmp = array();
			foreach ( $rows as $row ) {
				$this->addEntity( $row );
				$ids[] = $row->id;
				$wrk[ $row->id_parent ][ $row->id ] = array();
				$tmp[ $row->id ] = &$wrk[ $row->id_parent ][ $row->id ];
			}
			$wrk = $tmp;
			$depth--;
		}
		return $res;
	}
	
	
	/**
	 * Возвращает все удаленные элементы
	 * @param bool $children добавить информацию о наличии детей
	 * @return array идентификатор => массив дочерних элементов
	 */
	public function getDeleted( $children=false ) {
		$table = $this->getDbElements();
		$rows = $table->fetchAll( $table->select()
			->where( 'is_deleted = 1' )
		);
		$res = array();
		$ids = array();
		foreach( $rows as $row ) {
			$this->addEntity( $row );
			$res[ $row->id ] = array();
			$ids[] = $row->id;
		}
		if ( $children ) {
			$rows = $table->fetchAll( $table->select()
				->where( 'id_parent IN ( '.implode(',', $ids).' )' )
				->order( 'ord' )
			);
			foreach( $rows as $row ) {
				$res[ $row->id_parent ][] = $row->id;
			}
		}
		return $res;
	}
	
	/**
	 * Возвращает контейнер Zend_Navigation меню
	 * Элементы меню добавляются в коллекцию
	 * Использование в скрипте вида:
	 * <code>
	 * echo $this->navigation()->menu(); // полный
	 * echo $this->navigation()->menu()->renderMenu($this->navigation()->findOneByLabel('Главное меню')); // частичный
	 * echo $this->navigation()->breadcrumbs(); // хлебные крошки
	 * </code>
	 * @return Zend_Navigation
	 */
	public function getNavigation() {
		$roleId = Main::getCurrentUserRole()->getRoleId();
		$roleId = str_replace('#','user',$roleId);
		if ( ! ( $navigation = $this->getCache()->load( 'Navigation_' . $roleId ) ) ) {
			$navigation = new Zend_Navigation();
			$menus = Model_Collection_Objects::getInstance()->getObjectsByType( 10, 'id' );
			/*if ( count( $menus ) == 1 ) {
				$navigation = $this->_getNavigationMenu( array_pop( $menus ), $navigation );
			}else {*/
				foreach ( $menus as $menu ) {
					$container = Zend_Navigation_Page_Uri::factory( array( 
						'id'    => $menu->id,
						'label' => $menu->title, // можно использовать для вывода разных меню по отдельности
                                                'class' => $menu->getValue('menu_class'),// $fields[0]->val_varchar,//стиль меню,  можно было через fields, но так быстрее работает
						'uri'   => '', // ссылка, можно заменить на $menu->getValue( 'menuroot_url' )
                                                
					) );
                                        $container->showSub = $menu->getValue('menu_collapsed');
					$navigation->addPage( $this->_getNavigationMenu( $menu, $container ) );
				}
			//}
			$this->getCache()->save( $navigation, 'Navigation_' . $roleId, array('Navigation','Elements') );
		}
		return $navigation;
	}
	
	/**
	 * Заполняет контейнер Zend_Navigation элементами меню
	 * @param Model_Entity_Object $menu объект данных меню
	 * @param Zend_Navigation_Container $container OPTIONAL контейнер для добавления страниц
	 * @return Zend_Navigation_Container
	 */
	protected function _getNavigationMenu( $menu, $container=null ) {
		if ( ! isset( $container ) ) {
			$container = new Zend_Navigation();
		}
                
		$lang_id = Main::getCurrentLanguage()->id;
		/*  // depricated
			$rows = $menu->findManyToManyRowset( 
			$this->getDbElements(), // целевая таблица
			$mco->getDbContent(),   // таблица пересечений
			'Object', 'TreeRel',    // ключи правил таблицы пересечений
			$this->getDbElements()->select()
				->where( 'id_lang = ?', $lang_id )
				->order( array( 'id_parent', 'ord' ) ) 
		);*/
		$rows = $menu->findDependentRowset(
			$this->getDbElements(),
			'Menu',
			$this->getDbElements()->select()
				->where( 'id_lang = ?', $lang_id )
				->order( array( 'id_parent', 'ord' ) ) 
		);
                $acl = Main::getAcl();
                $role = Main::getCurrentUserRole();
		// Добавляем все в контейнер
		foreach ( $rows as $row ) {
			$this->addEntity( $row );
			$page = $row->getPage();
                        if( $row->isReadable() ) {
                            if ( $page->isVisible() ) {
                                    $container->addPage( $page );
                            }
                        }
		}
		// Восстанавливаем связи
		foreach ( $rows as $row ) { // использовать foreach container нельзя из-за find
			if ( !empty( $row->id_parent ) ) {
				$parent = $container->findById( $row->id_parent );
				if ( isset( $parent ) ) {
					$page = $container->findById( $row->id );
					if ( !isset($page) ) continue;
					$page->setParent( $parent );
					$parent_element = $this->getEntity( $row->id_parent );
					if ( $parent_element->getValue( 'menu_showsub' ) ) {
						$page->setVisible( true );
					}
				}
			}
		}
		return $container;
	}
	
	/**
	 * Метод сортировки элементов, учитывающий значения полей; поле определяется типом первого элемента
	 * @param Model_Entity_Element $a
	 * @param Model_Entity_Element $b
	 * @return int
	 * @see usort()
	 */
	public function compare( $a, $b ) {
		$name = $a->getType()->getCompareBy();
		$av = $a->getValue( $name );
		$bv = $b->getValue( $name );
		if ( $av == $bv ) return 0;
		return ($av < $bv) ? -1 : 1;
	}
	
	/**
	 * Метод сортировки элементов в обратном порядке, учитывающий значения полей; поле определяется типом первого элемента
	 * @param Model_Entity_Element $a
	 * @param Model_Entity_Element $b
	 * @return int
	 * @see usort()
	 */
	public function compareRev( $a, $b ) {
		$name = $a->getType()->getCompareBy();
		$av = $a->getValue( $name );
		$bv = $b->getValue( $name );
		if ( $av == $bv ) return 0;
		return ($av > $bv) ? -1 : 1;
	}
}