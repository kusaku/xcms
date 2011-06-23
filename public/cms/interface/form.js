/*
 * Jquery Fs Form
 * form.js
 * Виджет, отвечает за работу с формами.
 * 
 * Version: $id: $
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 */

/*
 * Функция конструктор
 * @param (object) module		Модуль-владелец
 * @param (string)	controller	Рабочий контроллер    
 */
(function($) {
	$.widget("fs.form", {
		options: {
			module: null,
			controller: null,
                        pane: 0,
                        id: 0,
		},
		
		_create: function(){
			this._initForm();
		},
		
		/*
	 * Инициализация формы
	 */
		_initForm: function(){
			var self = this;
			self._getForm();
		},
		
		/*
		 * Получение объекта формы
		 */
		_getForm: function(){
			var self = this;
			var element = this.element;
			var o = self.options;
			var qString;
			if ( o.controller == 'content' ) {
				flash = document.getElementById('main_flash');
				if ( flash.reset )
					flash.reset();
			}
			//alert(o.viewform);
			if( o.viewform == 'dialog' ) {
				var form = $("#dialog-form").find("#editform");
				var id = o.target.data('context').id;
                                
				o.id = id;
				//o.action = 'new';
			} else {
				var form = element.find("#editform");
				var id = o.target.data('context').id;
				o.id = id;
			}
			//o.controller;// = o.target.data('context').controller;
			//alert(o.controller);
			//o.layout.panes[o.pane].element = o.target.data('context').element;
			//alert(o.target.data('context').controller);
			var url = self._getUrl( o.action, id );
			self.options.idContext = id;
			/*if( current )
				var parent = current.parents('li').eq(0);*/
			$.ajax({
				url: url,
				data: qString,
				type: 'get',
				dataType: 'json',
				beforeSend: function(){
					if ( o.viewform != 'dialog' ) {
						element.empty();
						element.append($('<div></div>').addClass('load'));
					}
				},
				error: function(){
					throw 'Error! Wrong JSON answer';
				},
				success: function(data){
					if (typeof data['id'] != 'undefined') {
						if (o.controller == 'news') 
							$('#jqmenu').treeform('initTreeMenu');
					}
					if (data['createElement'] == false) {
						o.addtoroot = false;
					}
					var error = $(data['form']).find('.panel .errors').is('*');
					if ( !error ) {
						self._updateForm( data );
					}
					else {
						self.off();
					}
				}
			});
                        return false;
		},
		
		/*
		 * Получение объекта формы
		 */
		_postForm: function( exitOnSubmit ){
			var self = this;
			var element = this.element;
			var o = this.options;
			var qString;
			if (o.controller == 'content') {
				flash = document.getElementById('main_flash');
				if (flash.reset) 
					flash.reset();
			}
			if( o.viewform == 'dialog' ) 
				var form = $("#dialog-form").find("#editform");
			else
				var form = element.find("#editform");
			if (typeof(tinyMCE) != "undefined") 
				for (edId in tinyMCE.editors) {
					tinyMCE.editors[edId].save();
				}
			qString = form.formSerialize(); // формирование строки с перемеными из формы
			var url = self._getUrl(  o.action, self.options.idContext );
			if( o.target )
				var parent = o.target.parents('li').eq(0);
			$.ajax({
				url: url,
				data: qString,
				type: 'post',
				dataType: 'json',
				beforeSend: function(){
					if ( o.viewform != 'dialog' ) {
						element.empty();
						element.append($('<div></div>').addClass('load'));
					}
				},
				error: function(){
					throw 'Error! Wrong JSON answer';
				},
				success: function(data){
					if (typeof data['id'] != 'undefined') {
						if ( o.update_tree ) { // если нужно обновлять дерево и режим post
							if (o.action == 'new' || o.action == 'newcategory') {
								self._trigger('append', 0, {data: data, element: element, parent: parent} );
								//current = node.children('div').eq(0);
							}
							else 
								if (o.action == 'edit') {
									o.target.children('a').text(data['title']);
								}
						}
						/*if (type == 'post') {
							action = 'edit';
							id = data['id'];
						}*/
						/*if (o.controller == 'news') 
							$('#jqmenu').treeform('initTreeMenu');*/
					}
					if (data['createElement'] == false) {
						o.addtoroot = false;
					}
					if(o.controller == 'data' && o.viewform == 'dialog' && (o.action == 'edit' || o.action == 'new'))
						o.viewform = 'panel';
					var error = $(data['form']).find('.panel .errors').is('*');
					if (!exitOnSubmit || error) {
						self._updateForm( data );
					}
					else {
						//o.container.empty();
						self.off();
					}
				}
			});
		},
		
		/*
		 * 
		 */
		_updateForm: function( data ){
			
		},
		
		/*
	 * Возвращает url
	 * @param (string) action Действие
	 * @param (int)    id     Индентификатор ноды
	 */
		_getUrl: function(action, id){
			var o = this.options;
			var url = '/' + o.module + '/' + o.controller + '/' + action;
			if (typeof id == 'number') {
			    console.log(action);
				url += '/' + o.layout.panes[o.pane].element;
				if (typeof id != 'undefined') {
					/*if ( id == 0 ) id = 'all';*/
					url += '/' + id;
				}
			}
			else 
				if ((typeof id == 'object') || (typeof id == 'array')) {
                                    console.log('vasvas');
					for (type in o.layout.panes) {
						if (typeof id[type] != 'undefined') {
							url += '/' + o.layout.panes[type].element + '/' + id[type];
						}
					}
				}
				else {
                                    alert('Алярма - всё плохо совсем!');
					throw 'Error! Wrong type of Id';
				}
			return url;
		},
		
		off: function() {
			//this._trigger('done', null, { tree: this } );
                        name = this.options.controller;
                        module = new Module();
                        module.name = name;
                        module.options = this.options;
                        //module.getLayout();
                        module.activateModule();
		}

	});
})(jQuery);