<?php
/**
 * 
 * Шаблон
 * 
 * @category   Xcms
 * @package    Model
 * @subpackage Model_Entity
 * @version    $Id: Template.php 211 2010-06-11 14:04:35Z renat $
 */

class Model_Entity_Template extends Model_Abstract_Entity {
	
	/**
	 * Расширение файлов шаблонов
	 * @var string
	 */
	protected static $_ext = 'phtml';
	
	/**
	 * Содержимое файла шаблона
	 * @var string
	 */
	protected $_content;
	
	/**
	 * Флаг изменения файла шаблона
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
	 * @return Model_Entity_Template $this
	 */
	public function setValues( $values ) {
		if ( isset($values['title']) and $this->title != $values['title'] ) 
			$this->title = $values['title'];
		if ( isset($values['language']) and $this->id_lang != $values['language']=(int)$values['language'] )
			$this->id_lang = $values['language'];
		if ( isset($values['filename']) ) {
			list($values['filename'])=explode('.', $values['filename'], 2);
			if ( $this->filename != $values['filename'] )
				$this->filename = $values['filename'];
		}
		if ( isset($values['default']) and $this->is_default != $values['default']=(int)$values['default'] ) {
			Model_Collection_Templates::getInstance()->setDefault( $this->id );
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
		$names = array( 'title', 'language' );
		$form->addElement( 'text', 'title', array(
			'label' => 'Название шаблона',
			'value' => $this->title,
			'description' => 'Название шаблона используемое в настройках страницы'
		));
		/*$form->addElement( 'select', 'language', array(
			'label' => 'Язык',
			'value' => $this->id_lang,
			'description' => 'Язык'
		));*/
		if( $this->id != 0 ){
			if ( ! file_exists( $this->getPath() ) ){
				throw new Model_Exception( 'Файл шаблона '.$this->filename.' не существует' );
			}
			$this->_content = file_get_contents( $this->getPath() );
		} else {
			$this->_content = file_get_contents( dirname( $this->getPath() ) . DIRECTORY_SEPARATOR . 'default.phtml' );
			if ( ! empty( $this->_content ) ) 
				$this->_contentModified = true;
		}
		$form->addElement( 'text', 'filename', 
			array(
				'label' => 'Имя Файла',
				'value' => $this->filename . '.' . self::$_ext,
				'description' => 'Имя Файла шаблона'
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
		$form->addElement( 'checkbox', 'default', array(
			'label' => 'Использовать по умолчанию',
			'value' => $this->is_default,
			'description' => 'Выбрать для использования основным шаблоном дизайна сайта'
		));
		$names[] = 'default';
		$form->addElement( 'textarea', 'code', array(
			'label' => 'Редактировать шаблон',
			'value' => $this->_content,
			'description' => 'Используется для редактирования содержимого шаблона'
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
			'template', 
			array('description' => 'Шаблон' )
		);
		$form->addDisplayGroupButtons( 'template', ($this->id ? 'edit' : 'add' ) );
		return $form;
	}
	
	/**
	 * Путь к файлу шаблона
	 * @return string
	 */
	public function getPath(){
		return 
			realpath( APPLICATION_PATH . '/../templates/scripts' ) 
			. DIRECTORY_SEPARATOR . $this->filename . '.' . self::$_ext;
	}
	
	/**
	 * Очищает кеш
	 * @return void
	 */
	public function removeCache() {
	}
	
	/**
	 * Сохранить в базу созданный тип объекта
	 * @return Model_Entity_Template $this
	 */
	public function commit() {
		try{
			if( $this->id == 0 ){
				if( ! file_exists( $this->getPath() ) ) {
   	 				$fp = fopen( $this->getPath(), "w" );
   	 				if( ! $fp ){
   	 					throw new Model_Exception( 'Не удалось создать файл шаблона ' . $this->filename );
   	 				}
    				fclose($fp);
   	 				chmod( $this->getPath(), 0644 );
				}else{
					throw new Model_Exception( 'Файл шаблона ' . $this->filename . ' уже существует' );
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