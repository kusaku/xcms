/*
 * jQuery UI Tree
 * 
 * Version: $id: $
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 */
(function($) {

$.widget("ui.tree", {
	
	options: {
		module: null,
		controller: null,
		types: null,
		animationSpeed: 500,
		toolbarShow: true,
		dialog: false
	},
	
	_create: function() {
		this._initTree();
	},
	
	_initTree: function(){
		var self = this, o = this.options;
		self.element.empty();
		self._loadChildren( self._getUrl( 'get', 0 ), self.element );
	},
	
	// создание элемента дерева - ноды
	_createNode: function( context ) {
		var self = this, o = this.options;
		var header = $('<div></div>') // Создаем заголовок элемента дерева
			.data('context', context)
			.addClass('tree-element-hover')
			.hover(
				function ( event ) {
					self._mouseInNode( event );
				}, 
				function ( event ) {
					self._mouseOutNode( event );
				}
			);
		header.droppable({
			accept		: context.accept,
			hoverClass	: 'dropOver',
			tollerance	: 'pointer',
			scope		: self.options.controller,
			over		: function(event, ui){
				var droppable = this;
				var expandable = $(droppable).data('context').expandable;
				if (expandable){
					var dragHandle = $(event.target);
					if( dragHandle.hasClass('tree-element-collapsed') ){
						this.expanderTime = window.setTimeout(
							function(){
								self._expandNode( event );
							},
							o.animationSpeed
						);
					}
				}
			},
			out			: function()
			{
				if (this.expanderTime){
					window.clearTimeout(this.expanderTime);
				}
			},
			drop        : function(event, ui){
				if (window.confirm("Вы собираетесь переместить страницу. Если вы уверены, нажмите 'Ок'")) {
					self._dropNode(event.target, ui.draggable);
				}
			}

		});

		var type = self._getType(context.id);
		if( !context.is_locked &&  typeof type.actions.edit != 'undefined' ){
			header.append(
				$('<a></a>')
					.attr('href', self._getUrl( 'edit', context.id ))
					.text(context.title)
					.bind('click',
						function( event ){
							//self._trigger( 'editElement', event, { tree: self, target: $(event.target) } );
							self._sendForm( context.id, 'edit', false, header, 'get'  );// TODO лучше использовать событие
							return false;
						}
					)
			);
		}else{
			header.text(context.title);
		}
		// Добавление картинки  и иконоки  в зависимости от того есть ли дети 
		if ( context.expandable )
			header
				.addClass('tree-element-collapsed')
				.bind('click',
					function( event ){
						if(!$(event.target).is('a') ){
							if($(event.target).hasClass('tree-element-collapsed'))
								self._expandNode( event );
							else
								self._collapseNode( event );
						}
					}
				);
		else
			header
				.addClass('tree-element-empty');
		var node = $('<li></li>').append( header ).addClass(context.elementClass);
		node.draggable({
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
		});
		return node;
	},
	
	_mouseInNode: function( event ){
		$(event.target).addClass('hightlight');
	},
	
	_mouseOutNode: function( event ){
		$(event.target).removeClass('hightlight');
	},
	
	_expandNode: function( event ) {
		var o = this.options;
		var target = $(event.target);
		if( target.is('img') )
			target = target.parents('div').eq(0);
		var node = target.parent('li');
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
	
	_collapseNode: function( event ) {
		var o = this.options;
		var target = $(event.target);
		if( target.is('img') )
			target = target.parents('div').eq(0);
		var node = target.parent('li');
		if ( !node ) throw( 'Error! Node is not exists' );
		node.children( 'ul' ).slideUp( o.animationSpeed );
		target.removeClass('tree-element-expanded');
		target.addClass('tree-element-collapsed');
		return this;
	},
	
	_getUrl: function( action, id ) {
		var o = this.options;
		var url = '/'+ o.module +'/'+ o.controller +'/' + action;
		if( typeof id == 'number' ){
			url += '/' + o.types[0].element;
			if ( typeof id != 'undefined' ) {
				/*if ( id == 0 ) id = 'all';*/
				url += '/' + id;
			}
		}else if( (typeof id == 'object') || (typeof id == 'array') ){
			for ( type in o.types ) {
				if ( typeof id[ type ] != 'undefined' ) {
					url += '/' + o.types[ type ].element + '/' + id[ type ];
				}
			}
		}else{
			throw  'Error! Wrong type of Id';
		}
		return url;
	},
	
	_getType: function( id ) {
		// TODO возвращать соотв. id тип
		return this.options.layout.panes[0];
		return null;
	},
	
	_loadChildren: function( url, parent ) {
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
				ul.slideDown( o.animationSpeed );
			}
		});
		return this;
	},
	
	_appendChildren: function( data, parent ) {
		var self = this;
		var count = data.length-1;
		$.each(data, function(i, item) {
			var node = self._createNode( item );
			if(count==i){
				node.addClass('ddddd');
			}
			parent.append( node );
		});
		return this;
	},
	
	_appendNode: function(node, parent){
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
				node.addClass('ddddd');
					
			}
		}
	},
	
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
		}else{
			node.remove();
		}
	},
	
	_dropNode: function( target, draggable ){
		var self = this;
		var droppable = target;
		if(droppable.parentNode == draggable)
			return;
		var id_droppable = $(droppable).data('context').id;
		var id_draggable = draggable.children('div').eq(0).data('context').id;
		var url = self._getUrl('move', id_draggable);
		url += '/dest/'+id_droppable;
		$.ajax({
			url: url,
			type: 'post',
			dataType: 'json',
			error: function(){
				throw 'Error! Moving is not possible';
			},
			success: function(){
				var parent = draggable.parents('li').eq(0);
				// Узнать последний ли элемент в наборе ul
				var isLast = ( draggable.siblings('li').size() == 0 ); 
				// Перетаскивание в родительский элемент
				var isDropToParent = (parent[0]==droppable.parentNode); 
				// Перетаскивание корневого элемента на кнопку добавить
				var isRootToRoot = ((typeof parent[0]=='undefined') && $(droppable).children('.add').is('*')); 
				if ( isLast && !isDropToParent && !isRootToRoot ) {
					var context = parent.children('div').data('context');
					// Удаление класса с минусом
					parent.children('div').removeClass('tree-element-expanded');
					// Создание Спайсера
					parent.children('div').addClass('tree-element-empty');
					context['expandable'] = false;
					parent.children('div').data('context', context);
					self._appendNode( draggable, $( droppable.parentNode ) );
					// Удаление тега <ul>
					parent.children('ul').remove();
				}else{
					self._appendNode( draggable, $( droppable.parentNode ) );
					var context = $(droppable).data('context');
					context['expandable'] = true;
				}
			}
		});
	},
	
	off: function() {
		this._trigger('done', null, { tree: this } );
	},
	
	destroy: function() {
		$.Widget.prototype.destroy.call( this );
		this.element.empty();
	}
});

})(jQuery);