/*
 * Jquery Fs MainTree
 * maintree.js
 * Виджет, отвечает за создание простого дерева для левого меню.
 * 
 * Version: $id: $
 * 
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 *  jquery.fs.tree.js
 */

(function($) {

$.widget("fs.maintree", $.fs.tree, {
	
	options:{
	},
	
	_create: function(){
		this._initSimple();
	},
	
	_initSimple: function(){
		var self = this, o = this.options, add;
		self._initTree();
		self.element.find('.tree-element').jeegoocontext('maincontextmenu', {
			livequery: true,
			widthOverflowOffset: 0,
			heightOverflowOffset: 1,
			submenuLeftOffset: -4,
			submenuTopOffset: -5,
			event: 'click',
			//openBelowContext: true,
			onShow: function(e, context){
				$(context).parents('div').eq(0).contextmenu('destroy');
				$(context).parents('div').eq(0).contextmenu({actions: self._getActions(), container: $('#maincontextmenu')});
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
						self._newitemElement($(context).parents('div').eq(0));
						break;
					case 'action_delete':
						self._deleteElement($(context).parents('div').eq(0));
						break;
					case 'action_copy':
						self._copyElement();
						break;
					default:
						return false;
				}
			},
			onHide: function(e, context){
			}
		})
		//self._createToolbar( 'tree-toolbar-locked' );
	},
        /*
        _getPanes: function(){
		// TODO возвращать соотв. id тип
		return this.options.layout.panes[this.pane];
	},*/
	_getUrl: function( action, id ){
		var o = this.options;
		var url = '/'+ o.module +'/'+ o.controller +'/' + action;
		if( typeof id == 'number' ){
                    
			url += '/' + o.layout.panes[o.pane].element;
                        //alert(o.ne);
			if ( typeof id != 'undefined' ) {
				/*if ( id == 0 ) id = 'all';*/
				url += '/' + id;
			}
		}else if( (typeof id == 'object') || (typeof id == 'array') ){
                    //alert('hurray');
			for ( type in o.types ) {
				if ( typeof id[ type ] != 'undefined' ) {
                                    url += '/' + /*o.types[ type ]*/o.layout.panes[o.pane].element + '/' + id[ type ];
				}
			}
		}else{
			throw  'Error! Wrong type of Id sds';
		}
		return url;
	},
	/*
	 * Метод по созданию скрытых тулбаров
	 * @param (string) name Имя тулбара
	 */
	_createToolbar: function( name ) {
		var self = this, o = this.options;
		var toolbar = $('<div class=tree-toolbar></div>');
		toolbar.addClass( name );
		if (name == 'tree-toolbar-locked') {
			toolbar.append($('<a></a>').addClass('tree-toolbar-btn-locked lockedIco').attr('title', 'Заблокировано'));
		}
		else {
			toolbar.append($('<a></a>').addClass('tree-toolbar-btn contextIco').attr('title', 'Контекстное меню'));
		}
		toolbar
			.unbind('mouseenter mouseleave')
			.hover(
				function(){
					toolbar.data('current').addClass('hightlight');
					
					toolbar.show();
				}, 
				function(){
					if ($('#maincontextmenu').css('display') == 'none') {
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
        _expandNode: function( event ) {
		var o = this.options;
		var target = $(event.target);
		/*if( target.is('img') )
			target = target.parents('div').eq(0);*/
                o.controller = target.data('context').controller;
                o.layout.panes[o.pane].element = target.data('context').element;
		var node = target.parents('li').eq(0);
		if ( !node ) throw 'Error! Node is not exists';
		if( target.data('context').expandable && !node.children().is( 'ul' ) ) {
			this._loadChildren( this._getUrl( 'get', target.data('context').id ), node );
		} else {
			node.children( 'ul' ).slideDown( o.animationSpeed );
		}
		target.removeClass('tree-element-collapsed');
		target.toggleClass('tree-element-expanded');
		return this;
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
	/*
 	* Создание ноды
 	* @param (object) node_options	Опции ноды
 	*/
	createNode: function( context ) {
		var self = this, o = this.options;
                //alert(context.controller)
                o.controller = context.controller;
                o.layout.panes[o.pane].element = context.element;
		var classElement;
		if( context.is_locked )
			classElement = 'tree-element-locked';
		else
			classElement = 'tree-element';
		var element = $('<div></div>') // Создаем заголовок элемента дерева
			.data('context', context)
			.addClass(classElement)
		element.append(
			$('<span></span>')
				.addClass('gradient')
		)
		var panes = self._getPanes(context.id);
		if( !context.is_locked /*&&  typeof panes.actions.edit != 'undefined' */){ //@TODO - придумать причинно-следственную связь
			element.append(
				$('<a></a>')
					.attr('href', self._getUrl( 'edit', context.id ))
					.text(context.title)
					.bind('click',
						function( event ){
							self._trigger('edit', event, {tree: this, target: element} );
							return false;
						}
					)
			);
		}else{
			element.text(context.title);
		}
		var expandable = $('<div></div>');
		if ( context.expandable ){
			expandable
				.addClass('tree-element-collapsed')
				.data('context', context)
				.bind('click',
					function(event){
						if (!$(event.target).is('a')) {
							if ($(event.target).hasClass('tree-element-collapsed')) 
								self._expandNode(event);
							else 
								self._collapseNode(event);
						}
				});
		}else
			expandable
				.addClass('tree-element-empty')
				.data('context', context);
		var header = $('<div></div>')
					.addClass('header')
					.data('context', context)
					.append( expandable ).append( element )
					.hover(
						function(event){
							self._mouseInNode(event);
						}, 
						function(event){
							self._mouseOutNode(event);
						})
		
		var node = $('<li></li>')
			.append( header )
                        .attr('id','element_'+context.id)
			.addClass(context.elementClass);
		/*node.draggable({
			containment : 'window',
			opacity     : 0.5,
			autoSize	: true,
			ghosting	: true,
			zIndex     	: 1,
			cursor		: 'move',
			helper		: 'clone',
			scope		: self.options.controller,		
			refreshPositions: true,
			drag		: function(event, ui){event.stopImmediatePropagation();},
			start		: function(event, ui){
				self.element.children('.tree-toolbar').hide();
				self.options.toolbarShow = false;
			},
			stop		: function(event, ui){
				self.options.toolbarShow = true;
			}
		});*/
		return node;
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
			var url = self._getUrl('delete', id);
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