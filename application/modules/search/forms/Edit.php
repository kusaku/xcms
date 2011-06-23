<?php
/**
 * Description of Edit
 *
 * @author aleksey.f
 */
class Search_Form_Edit extends Admin_Form_Edit {


    public function init() {
        parent::init();
        $reg = Zend_Registry::getInstance();
        $this->addElement(
                'checkbox',
                'search_active',
                array(
                    'label' => 'Включить поиск',
                    'value' => $reg->get('search_active'),
                    'description' => 'Включить/отключить модуль поиска'
                )
            );
        $this->addDisplayGroup(
                array('search_active'),
                'search_edit',
                array('description' => 'Настройки поиска' )
            );
        $this->addDisplayGroupButtons( 'search_edit', 'edit' );
        $this->setElementDecorators( array(
			array('Label', array('nameimg' => 'ico_help.gif')),
			'ViewHelper',
			'Errors',
			array('HtmlTag', array( 'class' => 'fullwidth' ))
		));
    }
}

