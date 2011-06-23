/*
 * jQuery UI TreeCatalog
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
$.widget("ui.treecatalog", $.ui.treeform, {
	
	_create: function() {
		var self = this;
		self.initTreeMenu();
	},
	
	_getUrl: function( action, id ) {
		var o = this.options;
		var url = '/'+ o.module +'/'+ o.controller +'/' + action;
		var last = 0;
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
});
})(jQuery);