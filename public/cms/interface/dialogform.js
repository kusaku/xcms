/*
 * dialogform.js
 * Класс модуля, отвечает за создание диалога с формой.
 */

/*
 * Функция конструктор 
 */

(function($) {
    $.widget("fs.dialogform", $.fs.form, {
            options:{},

            _create: function(){
                    this._initDialogForm();
            },

            _initDialogForm: function(){
                    var self = this;
                    $("#dialog-form").dialog('destroy');
                    self._initForm();
            },

            _updateForm: function( data ){
			var self = this;
			var o = this.options;
			var element = self.element;
                        var dialog_form = $('<div></div>')
			.attr({
				'id' : 'dialog-form',
				'title' : data['title']
			})
			.append( data['form'] );
			//element.html(data['form']);
                        dialog_form.find('form').append(
			$('<table></table>')
		);
		dialog_form.find('.zend_form > div').each(function(){
			var className = $(this).attr('class');
			var tr = $(this).wrap(
				$('<tr></tr>')
					.addClass(className)
			);
			var children = $(this).children();
			children.each(function(){
				$(this).parents('tr').append(this);
				$(this).wrap(
					$('<td></td>')
				);
			});
			tr.remove('div.'+className);
		});
		dialog_form.find('.zend_form > tr').each(function(){
			dialog_form.find('table').append(this);
		});
		element.append(dialog_form);
		element.find('input[type=checkbox]').checkbox();
		element.find('input[type=radio]').radio();
                var opt = this.options;
                var action_url = '';
                if(element.find('a').is('#file_uploader') ) {
                    for( var i = 0; i<data['params'].length; i++ ) {
                        action_url+='/' + data['params'][i];
                    }
                    new AjaxUpload('#file_uploader', {
                      // какому скрипту передавать файлы на загрузку? только на свой домен
                      action: action_url,
                      // имя файла
                      name: 'userfile',
                      // дополнительные данные для передачи
                      data: {
                      },
                      // авто submit
                      autoSubmit: true,
                      // формат в котором данные будет ответ от сервера .
                      // HTML (text) и XML определяются автоматически .
                      // Удобно при использовании  JSON , в таком случае устанавливаем параметр как "json" .
                      // Также установите тип ответа (Content-Type) в text/html, иначе это не будет работать в IE6
                      // отправка файла сразу после выбора
                      // удобно использовать если  autoSubmit отключен
                      onChange: function(file, extension){},
                      // что произойдет при  начале отправки  файла
                      onSubmit: function(file, extension) {},
                      // что выполнить при завершении отправки  файла
                      onComplete: function(file, response) {
                          $(".response_text").html('<br><br>'+response+action_url);
                          $('#main_flash').liquidcarousel({height:56, duration:200, hidearrows: true});
                          flash = document.getElementById( 'main_flash' );
                          toMain();
                          if(flash.reset) flash.reset();
                      }
                    });
                }
		$("#dialog-form").dialog("destroy");
		if (o.action == 'new') {
			$("#dialog-form").dialog({
				autoOpen: false,
				height: 270,
				width: 400,
				modal: true,
				buttons: {
					'Добавить': function() {
						var bValid = true;
						self._postForm( data );
                                                $(this).dialog('close');
                                                $('#dialog-form').remove();
					},
					'Отмена': function() {
						$(this).dialog('close');
						$('#dialog-form').remove();
					}
				},
				close: function() {
					$('#dialog-form').remove();
				}
			});
		}else{
			$("#dialog-form").dialog({
				autoOpen: false,
				height: 270,
				width: 400,
				modal: true,
				buttons: {
					'Сохранить': function() {
						var bValid = true;
						self._postForm( true );
						$(this).dialog('close');
						$('#dialog-form').remove();
					},
					'Отмена': function() {
						$(this).dialog('close');
						$('#dialog-form').remove();
					}
				},
				close: function() {
					$('#dialog-form').remove();
				}
			});
		}
		$('#dialog-form').dialog('open');

	}
    });
})(jQuery);