/*
 * jQuery UI TreeForm
 * 
 * Version: $id: $
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 *  jquery.ui.tree.js
 *  jquery.ui.treemenu.js
 *  
 */
(function($) {
$.widget("ui.treeform", $.ui.treemenu, {
	options: {
		container: null
	},
	
	currentAction: null,
	
	_create: function() {
		var self = this, o = this.options;
		self.initTreeMenu();
	},
	
	_initForm: function( target ){
		var self = this;
		var actionName = target.attr('name');
		if( actionName == 'newElement' )
			var currentAction = 'new';
		if( actionName == 'newcategoryElement')
			var currentAction = 'newcategory';
		else if( actionName == 'editElement' )
			var currentAction = 'edit';
		var current = self._getCurrentHeader( target );
		var id = current.data('context').id; //Id текущего элемента
		if( !id )
			throw 'Error! Current node ID is not defined' ;
		self._sendForm( id, currentAction, false, current, 'get'  );
	},
	
	_sendForm: function( id, action, exitOnSubmit, current, type ){
		var self = this;
		var element = this.element;
		var o = this.options;
		var qString;
		if( o.controller == 'content' ){
			flash = document.getElementById( 'main_flash' );
			if (flash.reset) flash.reset();
		}
		if( o.dialog ) 
			var form = $("#dialog-form").find("#editform");
		else
			var form = o.container.find("#editform");
		if( type == 'post' ){
			if(typeof(tinyMCE)!="undefined") for( edId in tinyMCE.editors ) {
				  tinyMCE.editors[edId].save();
			}
			qString = form.formSerialize(); // формирование строки с перемеными из формы
		}
		var url = self._getUrl( action, id );
		if( current )
			var parent = current.parents('li').eq(0);
		$.ajax({
			url: url,
			data: qString,
			type: type,
			dataType: 'json',
			beforeSend: function(){
				if(!o.dialog){
					o.container.empty();
					o.container.append(
						$('<div></div>')
							.addClass('load'));
				}
			},
			error: function(){
				throw 'Error! Wrong JSON answer';
			},
			success: function( data ){
				if( typeof data['id']!='undefined' ){
					if ( o.update_tree && (type == 'post') ) { // если нужно обновлять дерево и режим post
						if( action == 'new' ||  action == 'newcategory') {
							var node = self._createNode( data );
							if( !current ){
								self._appendNode( node, self.element );
							}else{
								self._appendNode( node, parent );
							}
							current = node.children('div').eq(0);
						} else if( action=='edit' ) {
							current.children('a').text(data['title']);
						}
					}
					if( type == 'post' ){
						action = 'edit';
						id = data['id'];
					}
					if( o.controller == 'news' )
						$('#jqmenu').treeform('initTreeMenu');
				}
				if( data['createElement'] == false ){
					o.addtoroot = false;
				}

				var error = $(data['form']).find('.panel .errors').is('*');
				if ( !exitOnSubmit || error) {
					self._updateForm( data, action, id, current );
				}
				else {
					//o.container.empty();
					self.off();
				}
			}
		});
	}, 
	
	_updateForm: function( data, action, id, current ){
		var self = this;
		var o = this.options;
		var element = self.element;
		if( o.dialog ){
			self._dialogForm( data, action, id, current ); // Функция для диалоговых окон
		}else{
			o.container.html( data['form'] );
			//Удаление фотографии
			o.container.find('.delete_photo').bind('click', function(){
				var empty = '';
				$(this).siblings('input[type=hidden]').val( empty );
				$(this).siblings('.photo_back').empty();
			});
			o.container.find('#upload_client').append('Загрузить');
			if(o.container.find('a').is('#upload_client')){
				new AjaxUpload('#upload_client', {
					// какому скрипту передавать файлы на загрузку? только на свой домен
					action: '/admin/response/upload/',
					// имя файла
					name: 'userfile',
					// дополнительные данные для передачи
					data: {
				    	cat : data['category_img']
				  	},
				  	// авто submit
				  	autoSubmit: true,
				  	// отправка файла сразу после выбора
				  	// удобно использовать если  autoSubmit отключен  
				  	onChange: function(file, extension){},
				  	// что произойдет при  начале отправки  файла 
				  	onSubmit: function(file, extension) {
				  		if (extension && /^(jpg|png|jpeg|gif)$/.test(extension)){
				  			$('#upload_client').siblings('.text_info').html('Загружается ' + file);
						} else {
							// extension is not allowed
							$('#upload_client').siblings('.text_info').html('Ошибка: только файлы изображений');
							// cancel upload
							return false;
						}
				  	},
				  	// что выполнить при завершении отправки  файла
				  	onComplete: function(file, response) {
						//alert('1: '+response);
				  		if(response=='error'){
				  			$('#upload_client').siblings('.text_info').html('Не удалось загрузить '+file);
				  		}
				  		else{
				  			$('.PhotoClient').val( response );
				  			$('#upload_client').siblings('.photo_back').html("<img src=/"+response+" />");
				  			$('#upload_client').siblings('.text_info').html(file + ' загружен ');
				  		}
				  	}
				});
			}
			//Загрузка Фотографии
			o.container.find('#upload').append('Загрузить');
			if(o.container.find('a').is('#upload')){
				new AjaxUpload('#upload', {
					// какому скрипту передавать файлы на загрузку? только на свой домен
					action: '/admin/'+o.controller+'/upload/element/'+id,
					// имя файла
					name: 'userfile',
					// дополнительные данные для передачи
					data: {
				    	cat : data['category_img']
				  	},
				  	// авто submit
				  	autoSubmit: true,
				  	// отправка файла сразу после выбора
				  	// удобно использовать если  autoSubmit отключен  
				  	onChange: function(file, extension){},
				  	// что произойдет при  начале отправки  файла 
				  	onSubmit: function(file, extension) {
				  		if (extension && /^(jpg|png|jpeg|gif)$/.test(extension)){
				  			$('#upload').siblings('.text_info').html('Загружается ' + file);
						} else {
							// extension is not allowed
							$('#upload').siblings('.text_info').html('Ошибка: только файлы изображений');
							// cancel upload
							return false;
						}
				  	},
				  	// что выполнить при завершении отправки  файла
				  	onComplete: function(file, response) {
						//alert('2: '+response);
				  		if(response=='error'){
				  			$('#upload').siblings('.text_info').html('Не удалось загрузить '+file);
				  		}
				  		else{
				  			var arr = response.split('/');
				  			var img = arr[arr.length-1];
				  			$('.Photo').val( img );
				  			//$('#upload').siblings('.photo_back').html("<img src=/"+response+" />");
							$(el_id).siblings('.photo_back').html("<img src=/"+o.controller+"/backend/"+img+" />");
				  			$('#upload').siblings('.text_info').html(file + ' загружен ');
				  		}
				  	}
				});
			}
			$('input[name=userfile]').click( function(){
				save_buttons.button('enable').attr('disabled', '');
			});
			o.container.find('.delete_photo').click( function(){
				save_buttons.button('enable').attr('disabled', '');
			});
			//self.createUploader();
			$('#curmod').text( ' / ' + 'Редактирование' );
			o.container.find("#formcontainer").accordion({animated: 'slide', 'autoHeight': false});
			var ajaxfilemanager = function(field_name, url, type, win) {
				var ajaxfilemanagerurl = "../../../../resources/tiny_mce/plugins/ajaxfilemanager/ajaxfilemanager.php";
				switch (type) {
					case "image":
						break;
					case "media":
						break;
					case "flash":
						break;
					case "file":
						break;
					default:
						return false;
				}
				tinyMCE.activeEditor.windowManager.open({
					url: "../../../../resources/tiny_mce/plugins/ajaxfilemanager/ajaxfilemanager.php?editor=tinymce&language=ru",
					width: 782,
					height: 440,
					inline : "yes",
					close_previous : "no"
				},{
					window : win,
					input : field_name
				});
			};
			if( !o.container.find('textarea.HtmlText').attr('disabled') ){
				o.container.find('textarea.HtmlText').tinymce({
					script_url : '/cms/resources/tiny_mce/tiny_mce.js',
					plugins : 'advimage,advlink,advhr,contextmenu,fullscreen,media,paste,table,safari',
					theme : 'advanced',
					//	content_css : "css/styles.css",
					language : "ru",
					theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,formatselect,fontsizeselect,forecolor,backcolor,|,fullscreen",
					theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,bullist,numlist,|,outdent,indent,|,undo,redo,|,link,unlink,anchor,image,cleanup,code",
					theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,media",
					theme_advanced_toolbar_location : "top",
					theme_advanced_toolbar_align : "left",
					theme_advanced_resizing : true,
					paste_strip_class_attributes : true,
					paste_remove_styles : true,
					paste_remove_styles_if_webkit: true,
					file_browser_callback : ajaxfilemanager,
					paste_use_dialog : false,
					apply_source_formatting : true,
					force_br_newlines : true,
					force_p_newlines : false,
					relative_urls : true,
					convert_urls : false,
					extended_valid_elements : "iframe[name|src|framespacing|border|frameborder|scrolling|title|height|width]",
					setup : function(ed) {
						ed.onChange.add(function(ed) {
							save_buttons.button('enable').attr('disabled', '');
						});
					}
				});
			}else{
				o.container.find('textarea.HtmlText').tinymce({
					script_url : '/cms/resources/tiny_mce/tiny_mce.js',
					mode : "textareas",
					theme : "advanced",
					readonly : true
				});
			}
			o.container.find('input.Date').datepicker({
				dateFormat  : "yy-mm-dd",
				showOn      : 'button',
				autoSize: true,
				buttonImage : '/cms/images/calendarIco.gif'
			});
			var template = o.container.find('#code');
			if( template.is('*') ){
				var editor = CodeMirror.fromTextArea('code', {
					width: "100%",
					onChange: function(){
						save_buttons.button('enable').attr('disabled', '');
					},
					parserfile: ["parsexml.js", "parsecss.js", "tokenizejavascript.js", "parsejavascript.js",
				             "php/js/tokenizephp.js", "php/js/parsephp.js",
				             "php/js/parsephphtmlmixed.js"],
				             stylesheet: ["/cms/resources/codemirror/css/xmlcolors.css", "/cms/resources/codemirror/css/jscolors.css", "/cms/resources/codemirror/css/csscolors.css", "/cms/resources/codemirror/js/php/css/phpcolors.css"],
				             path: "/cms/resources/codemirror/js/",
				             continuousScanning: 500
				});
			}
			o.container.find('#fieldset-fields').fields({
				container: o.container,
				module: 'admin',
				controller: 'data',
				types: [
				  {
					  element: 'otype/' + id + '/group',
					  actions: { 
				      	'delete' : 'Удалить группу полей',
				      	'edit'   : 'Редактировать группу полей',
				      	'new'    : 'Создать поле'
			   		  }
			      },
			      {
			    	  element: 'field',
			    	  actions:{
			    	  	'delete' : 'Удалить поле',
			    	  	'edit'   : 'Редактировать поле'
				  	  }
			      }
			    ],
			    dialog: true,
			    update_tree: false,
			    done: function(){
					o.container.fields('destroy');
					self._sendForm( id, action, false, current, 'get' );
				}
			});
                        o.container.find('#fieldset-dumps').fields({
				container: o.container,
				module: 'admin',
				controller: 'install',
				types: [
				  {
					  element: 'system/1/dumps',
					  actions: {
                                            'new'   : 'Создать снимок '
			   		  }
			      },
			      {
			    	  element: 'file',
			    	  actions: {
			    	  	'delete' : 'Удалить снимок'
				  }
			      }
			    ],
			    dialog: true,
			    update_tree: false,
			    done: function(){
					o.container.fields('destroy');
					self._sendForm( id, action, false, current, 'get' );
				}
			});
                        o.container.find('#fieldset-modules').fields({
				container: o.container,
				module: 'admin',
				controller: 'install',
				types: [
				  {
					  element: 'system/2/mods',
					  actions: {
                                            'new'    : 'Установить модуль'
			   		  }
			      },
			      {
			    	  element: 'modules',
			    	  actions:{
			    	  	'delete' : 'Удалить модуль'
				  }
			      }
			    ],
			    dialog: true,
			    update_tree: false,
			    done: function(){
					o.container.fields('destroy');
					self._sendForm( id, action, false, current, 'get' );
				}
			});
			o.container.find('input:submit, button').button();
			var save_buttons = o.container.find('input:submit, button[name^=save]');
			save_buttons.each( function() {
				if ( this.disabled ) {
					$(this).button('disable');
				}
			});
			if (action == 'edit') {
				o.container.find(':input').focus( function(){
					save_buttons.button('enable').attr('disabled', '');
				});
			}
			// Формируем строку с id селектов
			var st = "";
			$('.halfwidth select').each(function(){
				st = st.concat(', '+'#'+this.id);
				
			});
			st = st.substr(2);
			o.container.find('.header').click(
				function(event){
					var panel = $(event.target).parents('div.panel');
					var cont = panel.children('.content');
					if ( cont.css("display")=='none' ) {
						cont.slideDown( o.animationSpeed, function(){panel.attr('style', 'overflow:visible');} );
						$(this).removeClass('arrow_down').addClass('arrow_up').attr('title', 'Свернуть');
						// Обновляем селекты так как они были скрыты.
						var params = {
							refreshEl: st,
							visRows: 5,
							scrollArrows: true
						};
						cuSelRefresh(params);
					} else {
						cont.slideUp( o.animationSpeed );
						panel.attr('style', 'overflow:hidden');
						$(this).removeClass('arrow_up').addClass('arrow_down').attr('title', 'Развернуть');
					}
			});
			o.container.find('input[type=checkbox]').not('.viewcheckbox').not('.editcheckbox').checkbox();
			o.container.find('input[type=checkbox].viewcheckbox').checkbox({
				classTag: 'viewCheck',
				multiCheckbox: true
			});
			o.container.find('input[type=checkbox].editcheckbox').checkbox({
				classTag: 'editCheck',
				multiCheckbox: true
			});
			o.container.find('span[class^=nice]').click( function(){
				save_buttons.button('enable').attr('disabled', '');
			});
			o.container.find('span[class$=Check]').click( function(){
				save_buttons.button('enable').attr('disabled', '');
			});
			o.container.find('input[type=radio]').radio();
			// Стилизация селектов
			var params = { //Установка параметров
					changedEl: ".halfwidth select",
					visRows: 5,
					scrollArrows: true
			};
			cuSel(params);
			o.container.find('.cusel').click( function(){
				save_buttons.button('enable').attr('disabled', '');
			});
		//	DD_belatedPNG.fix('.niceRadio, .cusel, .cuselFrameRight, .jScrollPaneDrag, .jScrollArrowUp, .jScrollArrowDown, .cusel-repeat');
			o.container.find('button[name^=cancel]')
				.unbind('click')
				.bind('click',
					function(){
						self.off();
					}
				);
			var exitOnSubmit = false;
			o.container.find('input[name^=save_exit]')
				.unbind('click')
				.bind('click',
					function(){
						exitOnSubmit = true;
				});
			o.container
				.unbind('submit')
				.submit(
					function(event){
						self._sendForm( id, action, exitOnSubmit, current, 'post' );
						return false;
					});
		}	
	},
	
	/* Вывод формы в диалоговое окно */
	_dialogForm: function( data, action, id, current ){
		var self = this;
		var o = this.options;
		var element = self.element;
		var dialog_form = $('<div></div>')
			.attr({
				'id' : 'dialog-form',
				'title' : data['title']
			})
			.append( data['form'] );
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
		o.container.append(dialog_form);
		o.container.find('input[type=checkbox]').checkbox();
		o.container.find('input[type=radio]').radio();
                var opt = this.options;
                var action_url = '';
                if(o.container.find('a').is('#file_uploader') ) {
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
                          $(".response_text").html('<br><br>'+response);
                          $('#main_flash').liquidcarousel({height:56, duration:200, hidearrows: true});
                          flash = document.getElementById( 'main_flash' );
                          toMain();
                          if(flash.reset) flash.reset();
                      }
                    });
                }
		$("#dialog-form").dialog("destroy");
		if (action == 'new') {
			$("#dialog-form").dialog({
				autoOpen: false,
				height: 270,
				width: 400,
				modal: true,
				buttons: {
					'Добавить': function() {
						var bValid = true;
						self._sendForm( id, action, true, current, 'post' );
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
						self._sendForm( id, action, true, current, 'post' );
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
		$('#curmod').text( ' / ' + 'Редактирование' );
	},
	/* Новый элемент */
	newElement: function( event, target ){
		this._initForm( target );
		return this;
	},
	
	/* Новый элемент категории*/
	newcategoryElement: function( event, target ){
		this._initForm( target );
		return this;
	},
	
	/* Редактирование элемента */
	editElement: function( event, target ){
		this._initForm( target );
		return this;
	},
	
	createUploader: function(){
       /* var uploader = new qq.FileUploader({
            element: document.getElementById('upload'),
            action: '/admin/content/upload/',
            allowedExtensions: ['png', 'jpeg', 'jpg'],
            onSubmit: function(id, fileName){
        	
        	},
        	onComplete: function(id, fileName, responseJSON){
        		
        	}

        });  */         
    }

	
});
})(jQuery);