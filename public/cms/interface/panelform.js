/*
 * Jquery Fs PanelForm
 * panelform.js
 * Виджет, отвечает за создание простой формы.
 * 
 * Version: $id: $
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 *	jquery.fs.form.js
 */
(function($) {
	$.widget("fs.panelform", $.fs.form, {
		options:{},
		
		_create: function(){
			this._initPanelForm();
		},
		
		_initPanelForm: function(){
			var self = this;
			self._initForm();
		},
		
		/*
 		* Обновление формы
 		*/
		_updateForm: function( data ){
			var self = this;
			var o = this.options;
			var element = self.element;
			element.html(data['form']);
				//Загрузка Фотографии
                                var id = o.id;
				element.find('#upload').append('Загрузить');
				if (element.find('a').is('#upload')) {
					new AjaxUpload('#upload', {
						// какому скрипту передавать файлы на загрузку? только на свой домен
						action: '/admin/' + o.controller + '/upload/element/' + id,
						// имя файла
						name: 'userfile',
						// дополнительные данные для передачи
						data: {
							cat: data['category_img']
						},
						// авто submit
						autoSubmit: true,
						// отправка файла сразу после выбора
						// удобно использовать если  autoSubmit отключен  
						onChange: function(file, extension){
						},
						// что произойдет при  начале отправки  файла 
						onSubmit: function(file, extension){
							if (extension && /^(jpg|png|jpeg|gif)$/.test(extension)) {
								$('#upload').siblings('.text_info').html('Загружается ' + file);
							}
							else {
								// extension is not allowed
								$('#upload').siblings('.text_info').html('Ошибка: только файлы изображений');
								// cancel upload
								return false;
							}
						},
						// что выполнить при завершении отправки  файла
						onComplete: function(file, response){
							if (response == 'error') {
								$('#upload').siblings('.text_info').html('Не удалось загрузить ' + file);
							}
							else {
								var arr = response.split('/');
								var img = arr[arr.length - 1];
								$('.Photo').val(img);
								$('#upload').siblings('.photo_back').html("<img src=/" + response + " />");
								$('#upload').siblings('.text_info').html(file + ' загружен ');
							}
						}
					});
				}
				$('input[name=userfile]').click(function(){
					save_buttons.button('enable').attr('disabled', '');
				});
				element.find('.delete_photo').click(function(){
					var empty = '';
					$(this).siblings('input[type=hidden]').val( empty );
					$(this).siblings('.photo_back').empty();
					$(this).empty();
					save_buttons.button('enable').attr('disabled', '');
				});
				$('#curmod').text(' / ' + 'Редактирование');
				element.find("#formcontainer").accordion({
					animated: 'slide',
					'autoHeight': false
				});
				var ajaxfilemanager = function(field_name, url, type, win){
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
						inline: "yes",
						close_previous: "no"
					}, {
						window: win,
						input: field_name
					});
				};
				if (!element.find('textarea.HtmlText').attr('disabled')) {
					element.find('textarea.HtmlText').tinymce({
						script_url: '/cms/resources/tiny_mce/tiny_mce.js',
						plugins: 'advimage,advlink,advhr,contextmenu,fullscreen,media,paste,table,safari',
						theme: 'advanced',
						//	content_css : "css/styles.css",
						language: "ru",
						theme_advanced_buttons1: "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,|,formatselect,fontsizeselect,forecolor,backcolor,|,fullscreen",
						theme_advanced_buttons2: "cut,copy,paste,pastetext,pasteword,|,bullist,numlist,|,outdent,indent,|,undo,redo,|,link,unlink,anchor,image,cleanup,code",
						theme_advanced_buttons3: "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,media",
						theme_advanced_toolbar_location: "top",
						theme_advanced_toolbar_align: "left",
						theme_advanced_resizing: true,
						paste_strip_class_attributes: true,
						paste_remove_styles: true,
						paste_remove_styles_if_webkit: true,
						file_browser_callback: ajaxfilemanager,
						paste_use_dialog: false,
						apply_source_formatting: true,
						force_br_newlines: true,
						force_p_newlines: false,
						relative_urls: true,
						convert_urls: false,
						verify_html: false,
						extended_valid_elements: "iframe[name|src|framespacing|border|frameborder|scrolling|title|height|width]",
						setup: function(ed){
							ed.onChange.add(function(ed){
								save_buttons.button('enable').attr('disabled', '');
							});
						}
					});
				}
				else {
					element.find('textarea.HtmlText').tinymce({
						script_url: '/cms/resources/tiny_mce/tiny_mce.js',
						mode: "textareas",
						theme: "advanced",
						readonly: true
					});
				}
				element.find('input.Date').datepicker({
					dateFormat: "yy-mm-dd",
					showOn: 'button',
					autoSize: true,
					buttonImage: '/cms/images/calendarIco.gif'
				});
				var template = element.find('#code');
				if (template.is('*')) {
					var editor = CodeMirror.fromTextArea('code', {
						width: "100%",
						onChange: function(){
							save_buttons.button('enable').attr('disabled', '');
						},
						parserfile: ["parsexml.js", "parsecss.js", "tokenizejavascript.js", "parsejavascript.js", "php/js/tokenizephp.js", "php/js/parsephp.js", "php/js/parsephphtmlmixed.js"],
						stylesheet: ["/cms/resources/codemirror/css/xmlcolors.css", "/cms/resources/codemirror/css/jscolors.css", "/cms/resources/codemirror/css/csscolors.css", "/cms/resources/codemirror/js/php/css/phpcolors.css"],
						path: "/cms/resources/codemirror/js/",
						continuousScanning: 500
					});
				}
				element.find('#fieldset-fields').fields({
					container: o.container,
					module: 'admin',
					controller: 'data',
					viewform: 'dialog',
					layout:{
						panes: [{
							element: 'otype/' + id + '/group',
							actions: {
								'delete': 'Удалить группу полей',
								'edit': 'Редактировать группу полей',
								'new': 'Создать поле'
							}
						}, {
							element: 'field',
							actions: {
								'delete': 'Удалить поле',
								'edit': 'Редактировать поле'
							}
						}]
					},
					dialog: true,
					update_tree: false,
					done: function(){
						o.container.fields('destroy');
						self._sendForm(id, action, false, current, 'get');
					}
				});

				element.find('input:submit, button').button();
				var save_buttons = element.find('input:submit, button[name^=save]');
				save_buttons.each(function(){
					if (this.disabled) {
						$(this).button('disable');
					}
				});
				if (o.action == 'edit') {
					element.find(':input').focus(function(){
						save_buttons.button('enable').attr('disabled', '');
					});
				}
				// Формируем строку с id селектов
				var st = "";
				$('.halfwidth select').each(function(){
					st = st.concat(', ' + '#' + this.id);
					
				});
				st = st.substr(2);
				element.find('.header').click(function(event){
					var panel = $(event.target).parents('div.panel');
					var cont = panel.children('.content');
					if (cont.css("display") == 'none') {
						cont.slideDown(o.animationSpeed, function(){
							panel.attr('style', 'overflow:visible');
						});
						$(this).removeClass('arrow_down').addClass('arrow_up').attr('title', 'Свернуть');
						// Обновляем селекты так как они были скрыты.
						var params = {
							refreshEl: st,
							visRows: 5,
							scrollArrows: true
						};
						cuSelRefresh(params);
					}
					else {
						cont.slideUp(o.animationSpeed);
						panel.attr('style', 'overflow:hidden');
						$(this).removeClass('arrow_up').addClass('arrow_down').attr('title', 'Развернуть');
					}
				});
				element.find('input[type=checkbox]').not('.viewcheckbox').not('.editcheckbox').checkbox();
				element.find('input[type=checkbox].viewcheckbox').checkbox({
					classTag: 'viewCheck',
					multiCheckbox: true
				});
				element.find('input[type=checkbox].editcheckbox').checkbox({
					classTag: 'editCheck',
					multiCheckbox: true
				});
				element.find('span[class^=nice]').click(function(){
					save_buttons.button('enable').attr('disabled', '');
				});
				element.find('span[class$=Check]').click(function(){
					save_buttons.button('enable').attr('disabled', '');
				});
				element.find('input[type=radio]').radio();
				// Стилизация селектов
				var params = { //Установка параметров
					changedEl: ".halfwidth select",
					visRows: 5,
					scrollArrows: true
				};
				cuSel(params);
				element.find('.cusel').click(function(){
					save_buttons.button('enable').attr('disabled', '');
				});
				element.find('button[name^=cancel]').unbind('click').bind('click', function(){
					self.off();
				});
				var exitOnSubmit = false;
				element.find('input[name^=save_exit]').unbind('click').bind('click', function(){
					exitOnSubmit = true;
				});
				element.unbind('submit').submit(function(event){
					self._postForm(exitOnSubmit);
					return false;
				});
		}
	});
})(jQuery);