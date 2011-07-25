$().ready(function(){
	var sss = '';
	var level = 0;
	var defval= 0;
	$('#category').children().each(function(){
		var arr = $.trim($(this).attr('label')).split('::');

		for (var i = level; i >= arr.length; i--) {
			sss += '</div>';
		}

		if (defval == 0) defval = $(this).val();
		name = $.trim($(this).attr('label').replace(/::/g,''));
		sss += '<div name="'+name+'" id="cat_tree_'+$(this).val()+'" value="'+$(this).val()+'" class="cat_tree_element" style="border: solid 1px black; margin: 5px;">'+name;
	
		level = arr.length;
	});

	for (var i = level; i >= 1; i--) {
		sss += '</div>';
	}

	$('#category').replaceWith('<div style="display: none;" id="cat_tree_0">'+sss+'</div><input type="hidden" name="category" id="category" value="'+defval+'"><div id="sel_place"></div>');
	$('#sel_place').html(create_select(0));
});

function create_select(parent, text){
	if (text != undefined){
		if ( parent == '...' )
			$('#category').val(text);
		else
			$('#category').val(parent);
	}

	if ( $('#cat_tree_'+parent).children().length > 0 ){
		var temp = 0;
		var res = '<select onChange="$(this).nextAll().remove();$(this).after(create_select($(this).val(), '+parent+'));" style="width: 180px;" class="catSelector">';
		if (parent != 0) res += '<option>...</option>';
		$('#cat_tree_'+parent).children().each(function(){
			res += '<option value="'+$(this).attr('value')+'">'+$(this).attr('name')+'</option>';
			temp = $(this).attr('value');
		});
		res += '</select>';
		if ( $('#cat_tree_'+parent).children().length == 1 )	res += create_select(temp);
		
		return res;
	} else return '';
};
