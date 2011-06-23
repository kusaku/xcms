<?php
/**
 * ViewHelper - Хелпер Фотографий в каталоге
 *
 * @category   Xcms
 * @package    Xcms_View
 * @subpackage Helper
 * @version    $Id:
 */
class Xcms_View_Helper_FormPhoto extends Zend_View_Helper_FormElement {
	/**
     * Generates a 'photo' element.
     *
     * @access public
     *
     * @param string|array $name If a string, the element name.  If an
     * array, all other parameters are ignored, and the array elements
     * are extracted in place of added parameters.
     * @param mixed $value The element value.
     * @param array $attribs Attributes for the element tag.
     * @return string The element XHTML.
     */
    public function formPhoto($name, $value = null, array $attribs = null)
    {
        $info = $this->_getInfo($name, $value, $attribs);
        extract($info); // name, value, attribs, options, listsep, disable
        if (isset($id)) {
            if (isset($attribs) && is_array($attribs)) {
                $attribs['id'] = $id;
            } else {
                $attribs = array('id' => $id);
            }
        }
        $hidden = $this->_hidden($name, $value, $attribs);
        $value = $this->view->escape($value);
        if(!empty($value)){
        	 $photo = $hidden."<a class='delete_photo'>Удалить</a><b class='text_info'>&nbsp;</b><div class='photo_back'><img src='/".$attribs['module']."/backend/".$value."' /></div>";
        }else{
        	 $photo = $hidden."<b class='text_info'>&nbsp;</b><div class='photo_back'></div>";
       	}
        return $photo;
    }

}