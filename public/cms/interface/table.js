/*
 * Jquery Fs PanelForm
 * table.js
 * Виджет, отвечает за создание таблицы.
 *
 * Version: $id: $
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.widget.js
  */
(function($) {
	$.widget("fs.table", {
            options:{
                pane: 0,
                module : 'admin'
            },

            _create: function(){
                $.jgrid.no_legacy_api = true;
                $.jgrid.useJSON = true;
                this._initTable();
            },

            _initTable: function(){
                var self = this, o = this.options;
		self.element.empty();
                if(typeof o.layout.panes[o.pane].addtoroot != 'undefined') {
                    self._addHeader(o.layout.panes[o.pane].addtoroot);
                }
                self._loadChildren( self._getUrl( 'get', 0 ), self.element );
            },

             /*
            * Запрос на получение элементов дерева, формирование контейнера и вывод
            * @param (string) url	url - запрос на получение элементов
            * @param (object) parent	Родительский контейнер
            */
            _loadChildren: function( url, parent ){
		    var lastsel3;
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
                                    //var lastsel;
                                    var datas = self._getRows(data);
                                    parent.find('div.load').remove();
                                    $("#dataTable").remove();
                                    $("#pager").remove();
                                    var table = $('<table id="dataTable"></table>');
                                    parent.append(table);
                                    parent.append('<div id="pager"></div>');
                                    table.jqGrid({
                                        datatype: "local", 
                                        //url: '/admin/'+self.options.controller+'/get/'+self.options.layout.panes[self.options.pane].element+'/0' ,
                                        treedatatype: "local", 
                                        //width: 700 ,
                                        data: datas,
					height: 310,
                                        colNames:self._addHead2(data.fields),
                                        colModel : self._getModel(data.fields),
                                        pager: '#pager',
                                        
                                 //       treeGrid: true,
                                   //     treeGridModel: 'adjacency',
                                        rowNum:10,
                                        rowList:[10,20,30],
                                        sortname: 'id',
                                        ExpandColumn : 'id',
                                        autowidth: true, 
                                        sortorder: 'desc',
                                        viewrecords: true,
                                        subGrid: true,
					onSelectRow: function(id){
						if(id && id!==lastsel3){
							table.jqGrid('restoreRow',lastsel3);
							table.jqGrid('editRow',id,true);
							lastsel3=id;
							// замена номера заказа на ссылку для генерации накладной
							$('td[aria-describedby="dataTable_id"]').map(function(index){
								$(this).html($(this).attr('title'));
							});
							if(self.options.pane == 1)
								$('td[aria-describedby="dataTable_id"][title="'+id+'"]').html('<a href="' + self._getUrl('print', parseInt(id)) +'" target="_black" title="Распечатать накладную">' + id + '</a>');
							
							//$('td[aria-describedby="dataTable_id"]').html('<a href="###">qwe</a>');
						}
					},
					celledit: true,
                                        subgridtype: "json",
                                        editurl: '/admin/'+self.options.controller+'/edit'+self.options.layout.panes[self.options.pane].element+'/',
                                        
                                        subGridRowExpanded: function(subgrid_id, row_id) {
                                            // Получаем подтаблцу
                                            var subgrid_table_id, pager_id;
                                            subgrid_table_id = subgrid_id+"_t";
                                            pager_id = "p_"+subgrid_table_id;
                                            var url = '/admin/'+self.options.controller+'/get/'+self.options.layout.panes[self.options.pane].subelement+'/'+row_id;
                                            $.ajax(
                                            {
                                                url: url,
                                                type: 'post',
                                                dataType: 'json',
                                                error: function(){
                                                        throw( 'Error! Wrong JSON answer' );
                                                },
                                                success: function( data ){
                                                    $("#"+subgrid_id).html("<table id='"+subgrid_table_id+"' class='scroll'></table><div id='"+pager_id+"' class='scroll'></div>");
                                                    var dat = self._getRows(data);
                                                    $("#"+subgrid_table_id).jqGrid({
                                                    datatype: "local",
                                                    data:dat,
                                                    colNames:self._addHead2(data.fields),
                                                    colModel : self._getModel(data.fields),
                                                    rowNum:20,
                                                    pager: pager_id,
                                                    sortname: 'num',
                                                    sortorder: "asc",
                                                    height: '100%'
                                                });
                                                $("#"+subgrid_table_id).jqGrid('navGrid',"#"+pager_id,{edit:false,add:false,del:false})
                                                }
                                            });
                                            
	},
                                        
                                        
                                        caption: self.options.layout.panes[self.options.pane].title
                                    });
                                  table.jqGrid('navGrid','#pager',{edit:false,add:false,del:false, col: true}).navButtonAdd('#pager',{
                                       caption:"Столбцы", 
                                       buttonicon:"ui-icon-col", 
                                       onClickButton: function(){ 
                                               $("#dataTable").jqGrid('columnChooser',{
						   width:300,
						   height: 450
					       });
                                               //return false;
                                       }, 
                                       position:"last"
                                    });    
                                    table.jqGrid('filterToolbar',{stringResult: true,searchOnEnter : false}); 
                                  //table. 
                                  
                                
                            }
                    });

                    return this;
            },
            
            _getRows: function(data){
              var rows = [];
              var count = 0;
              $.each( data.data, function( i, item ) {
                 row = {};
                 row['id'] = i;
                 //row['cell'] = [];
                 $.each(data.fields, function(k , p){
                     var namez = p.name;
                     var itemz = item[namez];
                     //row['cell'].push(itemz.toString());
                     row[ namez.toString() ] = itemz.toString();
                     
                 });
                 rows.push(row);
                 count++;
             });  
            /* var z = {};
             z['total'] = 1;
             z['page'] = 1;
             z['records'] = count;
             z['rows'] = rows;*/
             return rows;
             //return z;
            },
            _showHide: function(t, fields) {
                $.each(fields, function(i, item) {
			t.fnSetColumnVis( i, item.visible );
                });
            },
            
            _addHeader: function(elem) {
                var self = this;
                var add = elem.title;
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
            
                        
            
            /*_addHead: function(data, table) {
                var self = this;
                var element = $('<thead></thead>');
                var se = $('<tr></tr>')
                $.each(data, function(i, item) {
			var node = self.createHeadNode( item );
			se.append( node );
                });
                element.append(se);
                table.append(element);
            },*/
            
            _addHead2: function(data) {
                var heads = [];
                
                $.each(data, function(i, item) {
			heads[i] = item.title;
                });
                heads.unshift('id');
                return heads;
                
            },
            _getModel: function(data) {
                var model = [];
                var tmp = [];
                $.each(data, function(i, item) {
			model[i] = {name:item.name, index: item.name, hidden: !item.visible, editable: true, edittype: item.edittype,editoptions: item.editoptions};

                });
                model.unshift({name:'id',index:'id',width:55});
                return model;
            },
            
            _appendChildren: function( children, parent ){
		var self = this;
		$.each(children, function(i, item) {
			var node = self.createNode( item );
			parent.append( node );
                });
                return this;
            },
            
            createHeadNode: function(item) {
                var element = $('<th>'+item.title+' <input type="text" class="search_init" value="" name="search_'+item.name+'"></th>');
                return element;
            },
            
            createNode: function(item) {
                element = $('<tr></tr>');
                element.append('<td>'+item.id+'</td>');
                $.each(item, function(k, data) {
                    element.append('<td>'+data+'</td>');
                });
                return element;
            },

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
			throw  'Error! Wrong type of 1 Id';
		}
		return url;
            }
        });
})(jQuery)