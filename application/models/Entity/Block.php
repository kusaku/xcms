<?php
/**
 * 
 * Шаблон блока
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: Block.php 2010-08-11 10:45:35Z alex $
 */

class Model_Entity_Block extends Model_Abstract_Entity {
	
	/**
	 * Расширение файлов шаблонов блока
	 * @var string
	 */
	protected static $_ext = 'phtml';
	
	/**
	 * Содержимое файла шаблона блока
	 * @var string
	 */
	protected $_content;
	
	/**
	 * Флаг изменения файла шаблона блока
	 * @var bool
	 */
	protected $_contentModified;
	
	/**
	 * Магический метод используемый при приведении объекта к строке
	 * @return string
	 */
	public function __toString() {
		return (string) $this->title;
	}
	
	/**
	 * Устанавливает значения из массива
	 * @param array $values
	 * @return Model_Entity_Block $this
	 */
	public function setValues( $values ) {
		if ( isset($values['title']) and $this->title != $values['title'] ) 
			$this->title = $values['title'];
		/*if ( isset($values['language']) and $this->id_lang != $values['language']=(int)$values['language'] )
			$this->id_lang = $values['language'];*/
                if ( isset($values['type']) ) {
                    $this->id_object = $values['type'];
                } else {
                    $this->id_object = 0;
                }
		if ( isset($values['filename']) ) {
			list($values['filename'])=explode('.', $values['filename'], 2);
			if ( $this->filename != $values['filename'] )
				$this->filename = $values['filename'];
		}
		if ( isset($values['code']) and $this->_content != $values['code'] ){
			$this->_content = $values['code'];
			$this->_contentModified = true;
		}
		return $this;
	}
	
        /**
	 * Возвращает форму редактирования типа объекта (в разработке)
	 * @todo еще поля, декораторы
	 * @return Zend_Form
	 */
	public function getEditForm() {
		$form = new Admin_Form_Edit();
		$names = array( 'title', 'type' );
		$form->addElement( 'text', 'title', array(
			'label' => 'Название блока',
			'value' => $this->title,
			'description' => 'Название блока используемое при вызове блока на странице'
		));
                $mco = Model_Collection_ObjectTypes::getInstance();
                $types[0] = 'Текстовый блок';
                $types += $mco->getGuides();
                $form->addElement( 'select', 'type', array(
			'label' => 'Тип данных',
			'multiOptions' => $types,
                        'value' => $this->id_object,
			'description' => 'Тип данных, размещенных в блоке'
		));
		if( $this->id != 0 ){
			if ( ! file_exists( $this->getPath() ) ){
				throw new Model_Exception( 'Файл шаблона блока '.$this->filename.' не существует' );
			}
			$this->_content = file_get_contents( $this->getPath() );
		} else {
			$this->_content = file_get_contents( dirname( $this->getPath() ) . DIRECTORY_SEPARATOR . 'block.phtml' );
			if ( ! empty( $this->_content ) ) 
				$this->_contentModified = true;
		}
		$form->addElement( 'text', 'filename', 
			array(
				'label' => 'Имя Файла',
				'value' => $this->filename . '.' . self::$_ext,
				'description' => 'Имя Файла шаблона блока'
			) + 
			( $this->id != 0 ? array( 
				'disabled' => true 
			) : array( 
				'validators' => array( 
					array( 'Regex', true, array('/^[a-z0-9_]+\.' . self::$_ext . '$/') ),
					array( 'File_NotExists', true, array( dirname($this->getPath()) ) ), 
				)
			) ) 
		);
		$names[] = 'filename';
		$form->addElement( 'textarea', 'code', array(
			'label' => 'Редактировать блок',
			'value' => $this->_content,
			'description' => 'Используется для редактирования содержимого блока'
		));
		$form->setElementDecorators( array(
			array('Label', array('nameimg' => 'ico_help.gif')), 
			'ViewHelper',
			'Errors',
			array('HtmlTag', array( 'class' => 'fullwidth_content' ))
		));
		$names[] = 'code';
		/*$lang_opt = Model_Collection_Languages::getInstance()->fetchAll();
		$lang_opt = array( 'По умолчанию' ) + $lang_opt;
		$form->language->setMultiOptions( $lang_opt );*/
		$form->addDisplayGroup( 
			$names, 
			'block', 
			array('description' => 'Шаблон блока' )
		);
		$form->addDisplayGroupButtons( 'block', ($this->id ? 'edit' : 'add' ) );
		return $form;
	}
	
	/**
	 * Путь к файлу шаблона блока
	 * @return string
	 */
	public function getPath(){
		return 
			realpath( APPLICATION_PATH . '/../templates/scripts/block' ) 
			. DIRECTORY_SEPARATOR . $this->filename . '.' . self::$_ext;
	}
	
	/**
	 * 
	 * Путь до шаблонов блоков
	 */
	public function getBlockPath() {
		return 
			realpath( APPLICATION_PATH . '/../templates/scripts/block/' ); 
	}
	
	/**
	 * Имя файла шаблона
	 */
	public function getFilename() {
		return $this->filename . '.' . self::$_ext;
	}
	
	/**
	 * Очищает кеш
	 * @return void
	 */
	public function removeCache() {
	}
	
	/**
	 * Сохранить в базу созданный тип объекта
	 * @return Model_Entity_Block $this
	 */
	public function commit() {
		try{
			if( $this->id == 0 ){
				if( ! file_exists( $this->getPath() ) ) {
   	 				$fp = fopen( $this->getPath(), "w" );
   	 				if( ! $fp ){
   	 					throw new Model_Exception( 'Не удалось создать файл блока ' . $this->filename );
   	 				}
    				fclose($fp);
   	 				chmod( $this->getPath(), 0644 );
				}else{
					throw new Model_Exception( 'Файл шаблона блока ' . $this->filename . ' уже существует' );
				}	
			}
			if ( !empty( $this->_modifiedFields ) ) {
				$this->save();
				$this->removeCache();
			}
			if( isset( $this->_contentModified ) ) {
				file_put_contents( $this->getPath(), $this->_content );
				$this->_contentModified = false;
			}
		} catch ( Exception $e ) {
			throw new Model_Exception( $e );
		}
		return $this;
	}
}
