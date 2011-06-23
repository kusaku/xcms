/*
 * Jquery Fs SimpleTree
 * simpletree.js
 * Виджет, отвечает за создание простого дерева.
 * 
 * Version: $id: $
 * 
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 *  jquery.fs.tree.js
 */
var i;i = 0;
(function($) {

$.widget("fs.simpletree", $.fs.tree, {
	options:{
	},
	
	_create: function(){
		$('body').find('#contextmenu').expire().remove();
		$('body').append('<ul id="contextmenu" class="jeegoocontext cm_default"></ul>');
		this._initSimple();
	},
	
	_initSimple: function(){
		var self = this, o = this.options, add;
		self._initTree();
		self.element.find('.tree-element').expire();
		self.element.find('.tree-element').jeegoocontext('contextmenu', {
			livequery: true,
			widthOverflowOffset: 0,
			heightOverflowOffset: 1,
			submenuLeftOffset: -4,
			submenuTopOffset: -5,
			event: 'click',
			//openBelowContext: true,
			onShow: function(e, context){
				$(context).parents('div').eq(0).contextmenu('destroy');
				$(context).parents('div').eq(0).contextmenu({actions: self._getActions(), container: $('#contextmenu')});
			},
			onSelect: function(e, context){
				switch ($(this).attr('id')) {
					case 'action_edit':
						self._editElement($(context).parents('div').eq(0));
						break;
					case 'action_new':
						self._newElement($(context).parents('div').eq(0));
						break;
					case 'action_newsub':
						self._newElement($(context).parents('div').eq(0));
						break;
					case 'action_newitem':
						//console.log ($(context).parents('div').eq(0));
						self._newitemElement($(context).parents('div').eq(0));
						break;
					case 'action_delete':
						self._deleteElement($(context).parents('div').eq(0));
						break;
					case 'action_copy':
						self._copyElement();
						break;
					// костыль для модуля "Типы данных"
					case 'action_newfield':
						self._newField($(context).parents('div').eq(0));
						break;
					case 'action_editfield':
						self._editField($(context).parents('div').eq(0));
						break;
					case 'action_deletefield':
						self._deleteField($(context).parents('div').eq(0));
						break;
                                        // конец костыля
					default:
						return false;
				}
				//alert(1);
				$('body').find('#contextmenu').expire();
			},
			onHide: function(e, context){
			}
		})
		//self._createToolbar( 'tree-toolbar-locked' );
	},
        
	/*
	 * Метод по созданию скрытых тулбаров
	 * @param (string) name Имя тулбара
	 */
	_createToolbar: function( name ) {
		var self = this, o = this.options;
		var toolbar = $('<div class="tree-toolbar"></div>');
		toolbar.addClass( name );
		if( name == 'tree-toolbar-locked' ){
			toolbar.append(
					$('<a></a>')
						.addClass('tree-toolbar-btn-locked lockedIco')
						.attr('title', 'Заблокировано')
				);
		}
		else{
			var a = $('<a></a>')
						.addClass('tree-toolbar-btn contextIco')
						.attr('title', 'Контекстное меню')
						/*.bind('click', function( event ){
							toolbar.data('current').contextmenu('destroy');
							toolbar.data('current').contextmenu({actions: self._getPanes().actions, controller: o.controller});
							toolbar.data('current').addClass('active_contextmenu');
							toolbar.show();
						});*/
			toolbar.append(
					a
				);
		}
		toolbar
			.unbind('mouseenter mouseleave')
			.hover(
				function(){
					toolbar.data('current').addClass('hightlight');
					
					toolbar.show();
				}, 
				function(){
					if ($('#contextmenu').css('display') == 'none') {
						toolbar.data('current').removeClass('hightlight');
						toolbar.hide();
					}
				}
			);
		self.element.append( toolbar );
		var width = toolbar.width();
		toolbar.css('width', width + 'px');
		return toolbar;
	},
	
	_newElement: function ( event ){
		this._trigger('new', event, {tree: this, target: event} );
	},
        _newitemElement: function ( event ){
		this._trigger('newitem', event, {tree: this, target: event} );
	},
	_editElement: function ( event ){
		this._trigger('edit', event, {tree: this, target: event} );
	},
        
        _newField: function ( event ){
		this._trigger('newfield', event, {tree: this, target: event} );
	},
        _editField: function ( event ){
			console.log(event);
		this._trigger('editfield', event, {tree: this, target: event} );
	},
        _deleteField: function ( event ){
		this._trigger('deletefield', event, {tree: this, target: event} );
	},
	
	/*
	 * Удаление элемента из списка 
	 */
	_deleteElement: function ( current ){
		var self = this,  o = this.options;
		var expandable = current.data('context').expandable;
		var ul = current.parent('li').eq(0).children('ul').size();
		$('#dialog-confirm').remove();
		if ((expandable == false) || (ul == 0 && typeof expandable == 'undefined')) {
			var id = current.data('context').id; //Id текущего элемента
			if (!id) 
				throw 'Error! Current node ID is not defined';
			var url = self._getUrl('delete', id, 0);
			$('body').append($('<div></div>').attr({
				'id': 'dialog-confirm',
				'title': 'Удаление'
			}).append('<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Удалить выбранный элемент?</p>'));
			$("#dialog-confirm").dialog("destroy");
			$("#dialog-confirm").dialog({
				resizable: false,
				height: 140,
				modal: true,
				buttons: {
					'Да': function(){
						$.ajax({
							url: url,
							success: function(data){
								var node = current.parents('li').eq(0); // текущий элемент
								flash = document.getElementById('main_flash');
								
								if (o.controller == 'install') {
									/*$('#main_flash').liquidcarousel({height:56, duration:200, hidearrows: true});
							 if(flash.reset) flash.reset();*/
									//loadFlash();
									if (flash.reset) 
										flash.reset();
									toMain();
								//$('#main_flash').liquidcarousel({height:56, duration:200, hidearrows: true});
								
								}
								else {
									flash.updateTrash(data);
								}
								self._deleteNode(node);
								if (o.controller == 'news') 
									$('#jqmenu').treeform('initTreeMenu');
								
							}
						});
						$(this).dialog('close');
					},
					'Отмена': function(){
						$(this).dialog('close');
					}
				}
			});
		}
		else {
			$('body').append($('<div></div>').attr({
				'id': 'dialog-confirm',
				'title': 'Удаление'
			}).append('<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Удаление невозможно!<br /> Сначала  необходимо удалить все вложенные элементы.</p>'));
			$("#dialog-confirm").dialog("destroy");
			$("#dialog-confirm").dialog({
                            resizable: false,
                            height: 140,
                            modal: true,
                            buttons: {
                                'Ок': function(){
                                        $(this).dialog('close');
                                }
                            }
			});
		}
		return this;
	},

	_copyElement: function (){
		
	}
	
});
})(jQuery);
