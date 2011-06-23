<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
class System_Form_Module extends Admin_Form_Edit {
    public function init() {
        parent::init();
        $element = new Xcms_Form_Element_AjaxUpload('filename');
        $element->setLabel('Выбрать файл');
        $this->addElement($element);
    }

    public function  isValid($data) {
        parent::isValid($data);
        /*$file = $this->getElement('filename');
        if($file->isUploaded()) {
            return true;
        }
        return false;*/
    }

    
}
?>
