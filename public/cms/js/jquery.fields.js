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
 *  jquery.ui.treeform.js
 */
(function($) {
//$.widget("ui.fields", $.ui.treeform, {
$.widget("ui.fields", $.fs.tree, {
	options: {
		update_tree: false
	},
	
	_create: function() {
		var self = this;
		//self.initTreeMenu();
		self._initTree()
	},
	
	_appendChildren: function( data, parent ) {
		var self = this;
		$.each(data, function(i, group) {
			//var node = self._createNode( group );
			var node = self.createNode( group );
			node.addClass('group');
			parent.append( node );
			if( group.fields.length > 0 ){
				var ul = $( '<ul></ul>' );
				node.append(ul);
				var count = group.fields.length-1;
				$.each(group.fields, function(i, field){
					var node_field = self.createNode( field );
					if(count==i){
						node_field.addClass('ddddd');
					}
					ul.append( node_field );
				});
			}
		});
		return this;
	},
	
	_getUrl: function( action, id ) {
		var o = this.options;
		var url = '/'+ o.module +'/'+ o.controller +'/' + action;
		var last = 0;
		if( typeof id == 'number' ){
			url += '/' + o.layout.panes[0].element;
			//url += '/' + o.types[0].element;
			if ( typeof id != 'undefined' ) {
				/*if ( id == 0 ) id = 'all';*/
				url += '/' + id;
			}
		}else if( (typeof id == 'object') || (typeof id == 'array') ){
			for ( type in o.layout.panes ) {
				if ( typeof id[ type ] != 'undefined' ) {
					url += '/' + o.layout.panes[ type ].element + '/' + id[ type ];
					last = type;
				}
			}
		}else{
			throw  'Error! Wrong type of Id';
		}
		if ( (action == 'new') && (o.types.length > last) && (id!=0) ) {
			url += '/' + o.types[last+1].element + '/add';
		}
		return url;
	}
	
/*	_sendForm: function( id, action, exitOnSubmit, current, type ){
		var self = this;
		var element = this.element;
		var o = this.options;
		var qString;
		var form = $("#dialog-form").find("#editform");
		if( type == 'post' ){
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
			error: function(){
				throw 'Error! Wrong JSON answer';
			},
			success: function( data ){
				if( typeof data['id']!='undefined' ){
					if ( type == 'post' ) { // если нужно обновлять дерево и режим post
						if( action == 'new' ) {
							var node = self._createNode( data );
							node.addClass('group');
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
				}
				if ( !exitOnSubmit ) {
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
		self._dialogForm( data, action, id, current );
	}*/
});
})(jQuery);