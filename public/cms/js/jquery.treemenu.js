/*
 * jQuery UI TreeMenu
 * Дерево с тулбаром
 * 
 * Version: $id: $
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
 *  jquery.ui.tree.js
 */
(function($) {

$.widget("ui.treemenu", $.ui.tree, {
	options: {
		newElement: function( event, hash ) { 
			hash.tree.newElement( event, hash.target ); 
		},
		newcategoryElement: function( event, hash ) { 
			hash.tree.newcategoryElement( event, hash.target ); 
		},
		editElement: function( event, hash ) { 
			hash.tree.editElement( event, hash.target ); 
		},
		cloneElement: function( event, hash ) { 
			hash.tree.cloneElement( event, hash.target ); 
		},
		copyElement: function( event, hash ) { 
			hash.tree.cloneElement( event, hash.target ); 
		},
		deleteElement: function( event, hash ) { 
			hash.tree.deleteElement( event, hash.target ); 
		},
		restoreElement: function( event, hash ) { 
			hash.tree.restoreElement( event, hash.target ); 
		},
		done: function( event, hash ) {
			hash.tree.initTreeMenu();
		}
	},
	
	_create: function() {
		this.initTreeMenu();
	},
	
	initTreeMenu: function() {
		var self = this, o = this.options, add;
		self._initTree();
                if ( o.controller != 'install' ) {
                    if (typeof o.addtoroot != 'undefined') {
                            if( o.controller == 'news' )
                                    add = 'добавить ленту новостей';
                            else
                                    add = 'добавить';
                            var header = $( '<div></div>' )
                                    .data('context', {id: 0})
                                    .attr('class', 'add')
                                    .append(
                                            $('<a>')
                                                    .text(add)
                                                    .attr('href', self._getUrl('new', 0))
                                                    .bind('click',
                                                            function( event ){
                                                                    if ( o.addtoroot ) {
                                                                            self._sendForm( 0, 'new', false, false, 'get'  );// TODO лучше использовать событие
                                                                    }else{
                                                                            self._dialogErrorPage( o.maxpages );
                                                                    }
                                                                    return false;
                                                            }
                                                    )
                            );
                            self.element.prepend( $('<div></div>')
                                    .data('context', {id: 0})
                                    .attr('class', 'tree_header')
                                    .append(
                                            header.droppable({
                                                    accept		: '.content_, .news_category, .catalog_category, .articles_category, .feedback_, .bulletin_category, .faq_category, .search_',
                                                    hoverClass	: 'dropOver',
                                                    tollerance	: 'pointer',
                                                    scope		: self.options.controller,
                                                    drop        : function(event, ui){
                                                            if (window.confirm("Вы собираетесь переместить страницу. Если вы уверены, нажмите 'Ок'")) {
                                                                    self._dropNode(event.target.parentNode , ui.draggable);
                                                            }
                                                    }
                                            })
                                    )
                            );
                    }
                }
		for(type in o.types){
			var toolbar = self._createToolbar( 'tree-toolbar' + type, o.types[type] );
			self.element.append( toolbar );
			var width = toolbar.width();
			toolbar.css('width', width + 'px');
		}
		var toolbar = self._createToolbar('tree-toolbar-locked');
		self.element.append( toolbar );
		var width = toolbar.width();
		toolbar.css('width', width + 'px');
	},
	
	_createToolbar: function( name, type ) {
		var self = this, o = this.options;
		var toolbar = $('<div class=tree-toolbar></div>');
		toolbar.addClass( name );
		if( name == 'tree-toolbar-locked' ){
			toolbar.append(
					$('<a></a>')
						.addClass('tree-toolbar-btn-locked lockedIco')
						.attr('title', 'Заблокировано')
				);
		}
		else{
			$.each( type.actions, function(i, item) {
				var actionName = i;
				toolbar.append(
					$('<a></a>')
						.addClass('tree-toolbar-btn '+actionName+'Ico')
						.attr('name', actionName + 'Element')
						.attr('title', item)
						.data('toolbar', toolbar)
						.bind('click', function( event ){
							self._triggerToolbarAction( event );
						})
				);
			});
		}
		toolbar
			.unbind('mouseenter mouseleave')
			.hover(
				function(){
					toolbar.data('current').addClass('hightlight');
					toolbar.show();
				}, 
				function(){
					toolbar.data('current').removeClass('hightlight');
					toolbar.hide();
				}
			);
		return toolbar;
	},
	
	_mouseInNode: function( event ){
		var self = this;
		if( !self.options.toolbarShow )
			return;
		var target = $(event.target);
		if( target.is('a')  || target.is('img') ){
			target = target.parents('div').eq(0);
		}
		target.addClass('hightlight');
		this._positionToolbar( target );
	},
	
	_mouseOutNode: function( event ){
		var target = $(event.target);
		if( target.is('a') || target.is('img') ){
			target = target.parents('div').eq(0);
		}
		target.removeClass('hightlight');
		this.element.children('.tree-toolbar').hide();
		this.element.children('.tree-toolbar-locked').hide();
	},
	
	/* Метод по заданию позиционирования Тулбара */
	_positionToolbar: function( header ){
		var self = this;
		if( !self.options.toolbarShow )
			return;
		if ( !header ) throw 'Error! Node header is not exists';
		//var top = header.ui.position.top;
		var is_locked = header.data('context').is_locked;
		if( !is_locked ){
			var type =  typeof header.data('context').id == 'object' ? header.data('context').id.length-1 : 0;
			self.element.children('.tree-toolbar' + type)
				.show().position({
					of: header,
					my: 'right',
					at: 'right',
					collision: 'none none'
				})
				.data('current', header); // Сохраняем заголовок текущего элемента
				
		}
		else{
			self.element.children('.tree-toolbar-locked')
				.show().position({
					of: header,
					my: 'right',
					at: 'right',
					collision: 'none none'
				})
				.data('current', header); // Сохраняем заголовок текущего элемента

		}
	},
	
	_triggerToolbarAction: function( event ){
		var self = this;
		var actionName = $(event.target).attr('name');
		if ( ! self.options.hasOwnProperty( actionName ) ) {
			throw 'Error! Event ' + actionName + 'is undefined';
		}
		/* Запустить события которые описанны в методе _create */
		return self._trigger( actionName, event, {tree: self, target: $(event.target)} );
	},
	
	/* Новый элемент */
	newElement: function( event, target ){
		return this;
	},
	
	/* Новый элемент категории*/
	newcategoryElement: function( event, target ){
		return this;
	},
	
	/* Редактирование элемента */
	editElement: function( event, target ){
		return this;
	},

	/* Удаление элемента */
	deleteElement: function( event, target ){
		var self = this,  o = this.options;;
		var current = self._getCurrentHeader( target );
		var expandable = current.data('context').expandable;
		var ul = current.parent('li').eq(0).children('ul').size();
		$('#dialog-confirm').remove();
		if( ( expandable == false ) || ( ul==0 && typeof expandable=='undefined' ) ){
			var toolbar = target.data('toolbar'); //Тулбар
			var id = current.data('context').id; //Id текущего элемента
			if( !id )
				throw 'Error! Current node ID is not defined' ;
			var url = self._getUrl('delete', id);
			$('body').append(
				$('<div></div>')
					.attr({
						'id': 'dialog-confirm',
						'title': 'Удаление'
					})
					.append('<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Удалить выбранную страницу?</p>')
			);
			$("#dialog-confirm").dialog("destroy");
			$("#dialog-confirm").dialog({
				resizable: false,
				height:140,
				modal: true,
				buttons: {
					'Да': function() {
						$.ajax({
							url: url,
							success: function(data){
								var node = current.parents('li').eq(0); // текущий элемент
								flash = document.getElementById( 'main_flash' );
                                                                
                                                                if( o.controller == 'install' ) {
                                                                    /*$('#main_flash').liquidcarousel({height:56, duration:200, hidearrows: true});
                                                                    if(flash.reset) flash.reset();*/
                                                                    
                                                                    //loadFlash();
                                                                    if(flash.reset) flash.reset();
                                                                    toMain();
                                                                    //$('#main_flash').liquidcarousel({height:56, duration:200, hidearrows: true});
                                                                    
                                                                } else {
                                                                    flash.updateTrash( data );
                                                                }
								toolbar.hide();
								self._deleteNode( node );
								if( o.controller == 'news' )
									$('#jqmenu').treeform('initTreeMenu');
                                                                
							}
						});
						$(this).dialog('close');
					},
					'Отмена': function() {
						$(this).dialog('close');
					}
				}
			});
		}else{
			$('body').append(
					$('<div></div>')
						.attr({
							'id': 'dialog-confirm',
							'title': 'Удаление'
						})
						.append('<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Удаление невозможно!</p>')
				);
			$("#dialog-confirm").dialog("destroy");
			$("#dialog-confirm").dialog({
				resizable: false,
				height:140,
				modal: true,
				buttons: {
					'Ок': function() {
						$(this).dialog('close');
					}
				}
			});
		}
		return this;
	},

	/* Восстановление элемента */
	restoreElement: function( event, target ){
		var self = this;
		var current = self._getCurrentHeader( target );
		var toolbar = target.data('toolbar'); //Тулбар
		var id = current.data('context').id; //Id текущего элемента
		if( !id )
			throw 'Error! Current node ID is not defined' ;
		var url = self._getUrl('restore', id);
		if (window.confirm("Восстановить выбранную страницу?")) {
			$.ajax({
				url: url,
				success: function(data){
					var node = current.parents('li').eq(0);
					flash = document.getElementById( 'main_flash' );
					flash.updateTrash( data );
					toolbar.hide();
					self._deleteNode( node );
					$('#jqmenu').treeform('initTreeMenu');
				}
			});
		}
		return this;
	},
	
	/* Клонирование и создание виртуальной копии */
	cloneElement: function( event, target ){
		var self = this;
		var actionName = target.attr('name');
		if( actionName == 'copyElement' )
			var currentAction = 'copy';
		else if( actionName == 'cloneElement' )
			var currentAction = 'clone';
		var current = self._getCurrentHeader( target );
		var id = current.data('context').id; //Id текущего элемента
		if( !id )
			throw 'Error! Current node ID is not defined' ;
		var url = self._getUrl(currentAction, id);
		$.ajax({
			url: url,
			dataType: 'json',
			success: function(data){
				var node = self._createNode( data );
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
				current.parents('ul').eq(0).append( node );
			}
		});
		return this;
	},
	
	_getCurrentHeader: function( target ){
		var toolbar = target.data('toolbar'); //Тулбар 
		if( !toolbar )
			throw 'Error! Toolbar is not exists';
		var current = toolbar.data('current'); //Заголовок текущего элемента
		if( !current )
			throw 'Error! Current node header is not exists' ;
		return current;
	},
	
	_dialogErrorPage: function( maxpages ){
		$('#dialog-confirm').remove();
		$('body').append(
				$('<div></div>')
					.attr({
						'id': 'dialog-confirm',
						'title': 'Системное сообщение'
					})
					.append('<p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>Превышен лимит количества элементов сайта: максимум '+ maxpages +'</p>')
			);
		$("#dialog-confirm").dialog("destroy");
		$("#dialog-confirm").dialog({
			resizable: false,
			height:140,
			modal: true,
			buttons: {
				'Ок': function() {
					$(this).dialog('close');
				}
			}
		});
	}
});
})(jQuery);