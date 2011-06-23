<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of View
 *
 * @author kifirch
 */
class Model_Entity_View extends Model_Abstract_Entity {

        /**
	 * Расширение файлов шаблонов вида
	 * @var string
	 */
	protected static $_ext = 'phtml';

	/**
	 * Содержимое файла шаблона вида
	 * @var string
	 */
	protected $_content;

	/**
	 * Флаг изменения файла шаблона вида
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
	 * @return Model_Entity_View $this
	 */
	public function setValues( $values ) {
		if ( isset($values['title']) and $this->title != $values['title'] )
			$this->title = $values['title'];
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
			'label' => 'Название вида',
			'value' => $this->title,
			'description' => 'Название вида, используемое в системе'
		));
                
		if( $this->id != 0 ){
			if ( ! file_exists( $this->getPath() ) ){
				throw new Model_Exception( 'Файл шаблона '.$this->filename.' не существует' );
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
				'description' => 'Имя Файла шаблона',
				'disabled' => true,
			) );
		
		$names[] = 'filename';
		$form->addElement( 'textarea', 'code', array(
			'label' => 'Редактировать',
			'value' => $this->_content,
			'description' => 'Используется для редактирования содержимого'
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
			array('description' => 'Шаблон' )
		);
		$form->addDisplayGroupButtons( 'block', ($this->id ? 'edit' : 'add' ) );
		return $form;
	}

	/**
	 * Путь к файлу шаблона вида
	 * @return string
	 */
	public function getPath(){
                $module = Model_Collection_ElementTypes::getInstance()->getEntity($this->id_etype);
		return
			realpath( APPLICATION_PATH . '/../templates/scripts/'.$module->module )
			. DIRECTORY_SEPARATOR . $this->filename . '.' . self::$_ext;
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
   	 					throw new Model_Exception( 'Не удалось создать файл вида ' . $this->filename );
   	 				}
    				fclose($fp);
   	 				chmod( $this->getPath(), 0644 );
				}else{
					throw new Model_Exception( 'Файл шаблона вида ' . $this->filename . ' уже существует' );
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
?>
