<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Search
 *
 * @author aleksey.f
 */
class Catalog_Form_Search extends Zend_Form {

    public function  init() {
        parent::init();
        $this->setMethod('GET');
        $this->addElement(
            'select',
            'category',
            array(
                'label' => 'Категория',
            )
        );
        $this->addElement(
            'multiCheckbox',
            'search_field',
            array(
                'label' => 'Поля поиска',
				'class' => 'checker',
            )
        );
        $this->addElement(
            'text',
            'query',
            array(
                'label' => 'Искать слово',
            )
        );

        $this->addElement(
            'text',
            'min_price',
             array(
                 'label' => 'Мин. цена',
                 'validators' => array('digits')
             )
        );
        $this->addElement(
            'text',
            'max_price',
             array(
                 'label' => 'Макс. цена',
                 'validators' => array('digits')
             )
        );
        $this->addElement(
            'submit',
            'go',
            array(
                'label' => 'Искать'
            )
        );
	?>
	<script language="javascript">
		function check_checked(){
			var clear = true;
			$('#query').removeAttr('readonly');
			$('.checker').each(function(){
				if ( $(this).attr('checked') ){
					clear = false;
				}
			});
			if ( clear ) $('#query').attr('readonly', 'true').val('');
		}

		function check(){
			if ( $('#query').attr('readonly') ){
				$('.checker').attr('checked', true);
				$('#query').removeAttr('readonly');
			}
		}

		$(document).ready(function(){
			$('.checker').bind('click', check_checked); // Обрабатываем клики на чекбоксах.
			$('#query').bind('click', check); // При клике на заблокированное поле ввода расставлять галочки. Можно закомментить, если не этот функционал не нужен.
			check_checked(); // Проверяем, есть ли отмеченные чекбоксы. Допустим если форма вернулсась вместе с результатами поиска.
		});
	</script>
	<?php
    }

}
?>
