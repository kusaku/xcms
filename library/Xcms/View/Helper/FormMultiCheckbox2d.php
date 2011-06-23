<?php
/**
 * ViewHelper - двумерный MultiCheckbox
 *
 * @category   Xcms
 * @package    Xcms_View
 * @subpackage Helper
 * @version    $Id:
 */
class Xcms_View_Helper_FormMultiCheckbox2d extends Zend_View_Helper_FormRadio {
	
	/**
     * Input type to use
     * @var string
     */
    protected $_inputType = 'checkbox';
	
	public function formMultiCheckbox2d($name, $value = null, $attribs = null,
        $options = null, $listsep = "<br />\n")
    {
        $info = $this->_getInfo($name, $value, $attribs, $options, $listsep);
        extract($info); // name, value, attribs, options, listsep, disable

        // retrieve attributes for labels (prefixed with 'label_' or 'label')
        $label_attribs = array();
        foreach ($attribs as $key => $val) {
            $tmp    = false;
            $keyLen = strlen($key);
            if ((6 < $keyLen) && (substr($key, 0, 6) == 'label_')) {
                $tmp = substr($key, 6);
            } elseif ((5 < $keyLen) && (substr($key, 0, 5) == 'label')) {
                $tmp = substr($key, 5);
            }

            if ($tmp) {
                // make sure first char is lowercase
                $tmp[0] = strtolower($tmp[0]);
                $label_attribs[$tmp] = $val;
                unset($attribs[$key]);
            }
        }

        $labelPlacement = 'prepend';
        foreach ($label_attribs as $key => $val) {
            switch (strtolower($key)) {
                case 'placement':
                    unset($label_attribs[$key]);
                    $val = strtolower($val);
                    if (in_array($val, array('prepend', 'append'))) {
                        $labelPlacement = $val;
                    }
                    break;
            }
        }

        // the radio button values and labels
        $options = (array) $options;

        // build the element
        $xhtml = '';
        $list  = array();

        // ensure value is an array to allow matching multiple times
        $value = (array) $value;

        // XHTML or HTML end tag?
        $endTag = ' />';
        if (($this->view instanceof Zend_View_Abstract) && !$this->view->doctype()->isXhtml()) {
            $endTag= '>';
        }
   		 // should the name affect an array collection?
        	$name = $this->view->escape($name);
       		if ($this->_isArray && ('[]' != substr($name, -2))) {
            	$name .= '[]';
        	}
        // add radio buttons to the list.
        require_once 'Zend/Filter/Alnum.php';
        $filter = new Zend_Filter_Alnum();
        foreach ($options[0] as $opt_value_group => $opt_label_group) {
        	// Should the label be escaped?
        	if ($escape) {
                	$opt_label_group = $this->view->escape((string)$opt_label_group);
            }
        	// generate ID
            $optId = $id . '-' . $filter->filter($opt_value_group);
        	$list[] ='<span'
                    . $this->_htmlAttribs($label_attribs) . ' for="' . $optId . '" class="multi2d">'
                    .(('prepend' == $labelPlacement) ? $opt_label_group : '');
                    
            $input_name = rtrim($name, "\x5B..\x5D");
        	$input_name.= '['.$opt_value_group.'][]';
 
        	foreach ($options[1] as $opt_value => $opt_label) {
            	// Should the label be escaped?
            	if ($escape) {
                	$opt_label = $this->view->escape($opt_label);
            	}

           		 // is it disabled?
            	$disabled = '';
            	if (true === $disable) {
                	$disabled = ' disabled="disabled"';
            	} elseif (is_array($disable) && in_array($opt_value, $disable)) {
                	$disabled = ' disabled="disabled"';
            	}

            	// is it checked?
            	$checked = '';
            	if (!empty($value[$opt_value_group])) {
            		if(in_array($opt_value, $value[$opt_value_group]))
                		$checked = ' checked="checked"';
            	}
            	
            	
            	
            	// Wrap the radios in labels
            	$radio='<input type="' . $this->_inputType . '"'
                    . ' name="' . $input_name . '"'
                    . ' id="' . $optId . '"'
                    . ' class="' . $this->view->escape($opt_label) . 'checkbox"'
                    . ' value="' . $this->view->escape($opt_value) . '"'
                    . $checked
                    . $disabled
                    . $this->_htmlAttribs($attribs)
                    . $endTag;
                    
            	// add to the array of radio buttons
            	$list[] = $radio;
        	}
        	$list[] .=(('append' == $labelPlacement) ? $opt_label_group : '')
        				.'</span>';
        }

        // done!
        $xhtml .= implode($listsep, $list);
        return $xhtml;
    }
}