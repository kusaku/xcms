/*
 * Jquery Fs Tree
 * tree.js
 * Виджет, отвечает за создание дерева элементов.
 * 
 * Version: $id: $
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 */

(function($) {

$.widget("fs.tree", {
	
	options:{
		current:null,
                pane: 0,
		module:null,
		controller:null,
		toolbar:null,
		animationSpeed: 500
	},
	
	_create: function() {
		this._initTree();
	},
	
	/*
	 * Инициализация дерева
	 */
	_initTree: function(){
		var self = this, o = this.options;
		self.element.empty();
                if(typeof o.layout.panes[o.pane].addtoroot != 'undefined') {
                    self._addHeader(o.layout.panes[o.pane].addtoroot);
                }
		self._loadChildren( self._getUrl( 'get', 0 ), self.element );
	},


        _addHeader: function(elem) {
            var self = this;
            var add = elem.title;
            //alert(self.options.controller);
            var header = $( '<div></div>' )
                .data('context', {id: 0})
                .attr('class', 'add')
                .append(
                    $('<a></a>')
                        .text(add)
                        .attr('href', self._getUrl('new', 0))
                        .bind('click',
                            function( event ){
                                self._trigger('new', event, {tree: this, target: header.parent()});
                                return false;
                            }
                    )
                );
            self.element
                .prepend( $('<div></div>')
                .data('context', {id: 0})
                .attr('class', 'tree_header')
                .append(header));
         },
	/*
 	* Возвращает url
 	* @param (string) action Действие
 	* @param (int)    id     Индентификатор ноды
 	*/
	_getUrl: function( action, id ){
		var o = this.options;
		var url = '/'+ o.module +'/'+ o.controller +'/' + action;
		if( typeof id == 'number' ){
			url += '/' + o.layout.panes[o.pane].element;
			if ( typeof id != 'undefined' ) {
				/*if ( id == 0 ) id = 'all';*/
				url += '/' + id;
			}
		}else if( (typeof id == 'object') || (typeof id == 'array') ){
			for ( type in o.types ) {
				if ( typeof id[ type ] != 'undefined' ) {
                                    url += '/' + /*o.types[ type ]*/o.layout.panes[o.pane].element + '/' + id[ type ];
				}
			}
		}else{
			throw  'Error! Wrong type of Id';
		}
		return url;
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
	
	/* Метод срабатывает когда указатель мыши входит в область ноды
	 * @param (object) event объект ноды
	 */
	_mouseInNode: function( event ){
			var self = this;
			var target = $(event.target);
			if (!target.is('div.header')) {
				target = target.parents('div.header').eq(0);
			}
			target.addClass('hightlight');
			target.find('.gradient').addClass('hover_gradient');
	},
	
	/* Метод срабатывает когда указатель мыши выходит из области ноды
	 * @param (object) event объект ноды
	 */
	_mouseOutNode: function( event ){
			var target = $(event.target);
			if( !target.is('div.header')){
				target = target.parents('div.header').eq(0);
			}
			target.removeClass('hightlight');
			target.find('.gradient').removeClass('hover_gradient');
	},
	
	/*
	 * Открыть подменю
	 * @param (object) event объект ноды
	 */
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
	
	/*
	 * Закрыть подменю
	 * @param (object) event объект ноды
	 */
	_collapseNode: function( event ) {
		var o = this.options;
		var target = $(event.target);
	/*	if( target.is('img') )
			target = target.parents('div').eq(0);*/
		var node = target.parents('li').eq(0);
		if ( !node ) throw( 'Error! Node is not exists' );
		node.children( 'ul' ).slideUp( o.animationSpeed );
		target.removeClass('tree-element-expanded');
		target.addClass('tree-element-collapsed');
		return this;
	},
	
	/*
 	* Запрос на получение элементов дерева, формирование контейнера и вывод
 	* @param (string) url	url - запрос на получение элементов
 	* @param (object) parent	Родительский контейнер
 	*/
	_loadChildren: function( url, parent ){
		var self = this;
		var o = this.options;
		if ( !parent ) throw  'Error! Parent container is not exists';
		$.ajax( {
			url: url,
			type: 'post',
			dataType: 'json',
			beforeSend: function(){
				parent.append(
					$('<div></div>')
						.addClass('load'));
			},
			error: function(){
				throw( 'Error! Wrong JSON answer' );
			},
			success: function( data ){
				parent.find('div.load').remove();
				var ul = $( '<ul></ul>' ).hide();
				parent.append(ul);
				self._appendChildren( data, ul );
				/*ul.sortable({
					connectWith: "ul",
					placeholder: "ui-state-highlight",
					remove	: function(event, ui){alert('11');},
	             });*/
                                //f = [];
                                ul.nestedSortable({
					disableNesting: '.offers_item',
					forcePlaceholderSize: false,
					handle: 'div',
					helper:	'clone',
					items: 'li',
					opacity: .6,
					//placeholder: 'placeholder',
					tabSize: 25,
					tolerance: 'pointer',
					toleranceElement: '> div',
					connectWith: 'ul',
                                        start: function(event, ui) {
                                        },
                                        update: function(event, ui){
                                            
                                            $.ajax({
                                                type: 'post',
                                                data: ul.nestedSortable('serialize'),
                                                dataType: 'script',
                                                url: '/admin/content/move',
                                                complete: function(request){

                                                }
                                            });
                                        },
					listType: 'ul',
					revert: true,
					placeholder: "ui-state-highlight",
					containment : 'window'
				});

				ul.slideDown( o.animationSpeed );
			}
		});
		return this;
	},
	
	/*
 	* Добавление элементов  в контейнер
 	* @param (array)	children	Массив элементы
 	* @param (object) 	parent		Контейнер для добавления элементов	
 	*/
	_appendChildren: function( children, parent ){
		var self = this;
		$.each(children, function(i, item) {
			var node = self.createNode( item );
			parent.append( node );
			//node.find('.gradient').bind('click', function(){alert (1);})
		/*	node.find('.gradient').jeegoocontext('maincontextmenu', {
			livequery: true,
			widthOverflowOffset: 0,
			heightOverflowOffset: 1,
			submenuLeftOffset: -4,
			submenuTopOffset: -5,
			event: 'click',
			openBelowContext: true,
			onShow: function(e, context){
				alert(1)
			},
			onSelect: function(e, context){
			},
			onHide: function(e, context){
				alert(2)
			}
		})*/
		});
		return this;
	},
	
	appendNode: function( node, parent ){
		var self = this;
		var ul = parent.children('ul');
		var context = parent.children('div').eq(0).data('context');
		if( ul.is('*') ){
			// Есть дети
			ul.append(node);
		}else{
			if(!context.expandable){
				parent
					.append(
						ul = $('<ul></ul>')
				 			.append( node )
					)
					.children('div').eq(0)
						.removeClass('tree-element-empty')
						.addClass('tree-element-expanded')
						.toggle( 
							function(event){
								self._collapseNode( event );
							},
							function(event){
								self._expandNode( event );
							}
						);
				context = parent.children('div').data('context');
				context.expandable = true;
				parent.children('div').data('context', context);		
			}
		}
	},
	
	/*
	 * Удаление элемента из дерева
	 * @param {Object} node элемент дерева
	 */
	_deleteNode: function( node ){
		var isLast = ( node.siblings('li').size() == 0 ); // последний ли элемент в наборе ul
		if (isLast) {
			var parent = node.parents('li').eq(0);
			if (parent.length) {
				// Удаление класса с минусом
				parent.children('div').removeClass('tree-element-expanded');
				// Создание Спайсера
				parent.children('div').addClass('tree-element-empty');
				context = parent.children('div').data('context');
				context.expandable = false;
				parent.children('div').data('context', context);
			}
			node.remove();
			// Удаление тега <ul>
			parent.children('ul').remove();
		}
		else {
			node.remove();
		}
	},
	
	/*
	 * 
	 */
	_getPanes: function(){
		// TODO возвращать соотв. id тип
		return this.options.layout.panes[this.pane];
	},

        _getActions: function() {
            return this.options.actions[this.options.layout.panes[this.options.pane].element];
        }
	
});
})(jQuery);