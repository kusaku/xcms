<?php


class Xcms_Form_Element_AjaxUpload extends Zend_Form_Element {
    
    public $helper = "fileUploader";

    public $options;

    public function init()
    {
        
    }

    public function  render(Zend_View_Interface $view = null) {
        return '<div class="file"><div class="href"><a href="#" id="file_uploader">'.$this->getLabel().'</a></div><div class="response_text"><br><br></div></div>';
    }

}
