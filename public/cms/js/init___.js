/* Функция срабатывает при загрузки страницы */
$(function() {
	/*var i = 0;
	$('body').ajaxSend(function(evt, request, settings){
		i++;
		settings.url = settings.url+'/id_inquiry/'+i;
	});
	$('body').ajaxSuccess(function(evt, request, settings){
		var params = settings.url.split("/");
		var count = params.length;
		var id_inquiry = params[count-1];
		if(i!=id_inquiry){
			//request.abort();
			//request.removeEventListener();
			//settings.success = null;
			//evt.stopImmediatePropagation();
		}
	});*/
	mods = [];
	$.ajax({
		url: "/admin/module/get/all",
		type: 'post',
		beforeSend: function(){
			$('#module').empty().append(
				$('<div></div>')
					.addClass('load'));
		},
		dataType: 'json',
		success: function(data){
			$('#module').empty();
			$.each(data, function(module, option){
				option.container = $('#content');
				option.module = 'admin';
				if( option.dialog ) {
					option.update_tree = true;
					option.done = function() {};
				}
				if ( module == 'content' ) {
					option.update_tree = true;
					option.done = function(){
						$('#content').empty();
						toMain();
					};
					$('#jqmenu').treeform( 'destroy' );
					$('#jqmenu').treeform( option );
				} else if( !option.dialog ) {
					if ( option.type == 'editform' ) {
						option.done = function(){
							$('#content').empty();
							$('#content').editform( 'destroy' );
							toMain();
						};
					}
					else if ( option.type == 'response' ) {
						option.done = function(){
							$('#content').empty();
							$('#content').response( 'destroy' );
							toMain();
						};
					}
				}
				mods[module] = option;
			} );
		}
	});
	toMain();

	$('#logo a').bind('click', function( event ) {
		toMain();
		return false;
	} );

      $('#main_flash').liquidcarousel({height:56, duration:200, hidearrows: true});

    $('.menu_item').hover( function(){
        if($(this).attr('picture')=='config') pict='admin';
        else pict=$(this).attr('picture');
        $(this).attr('src', '/cms/images/menu/noflash/'+pict+'Over.png');
    }, function(){
          if($(this).attr('picture')=='config') pict='admin';
        else pict=$(this).attr('picture');
        $(this).attr('src', '/cms/images/menu/noflash/'+pict+'.png');
    }
    )

});

function moduleClick( name ) {
	var options = mods[name];
	$('#content').empty();
	$('#content').treeform( 'destroy' );
	$('#content').fields( 'destroy' );
	$('#content').editform( 'destroy' );
	$('#content').response( 'destroy' );
	$('#content').treecatalog( 'destroy' );
	if ( options.type == 'tree' ){
		$('#content').treeform( options );
	} else if ( options.type == 'tree_expanded') {
		$('#content').fields( options );
	} else if ( options.type == 'editform' ) {
		$('#content').editform( options );
	} else if ( options.type == 'response' ) {
		$('#content').response( options );
	} else if ( options.type == 'treecatalog' ){
		$('#content').treecatalog( options );
	} else {
		toMain();
	}
	$('#curmod').text( ' / ' + options.title );

    var controller =  options.controller;
    if(controller=='config') controller='admin';

   $('.menu_item').attr('src', function(){
         name =  $(this).attr('picture');
         if(name==controller){
            return  '/cms/images/menu/noflash/'+name+'Over.png';
        } else {
            return '/cms/images/menu/noflash/'+name+'.png';
        }
   });

    $('.menu_item').hover( function(){
        name =  $(this).attr('picture');
        if(name==controller){
             $(this).attr('src', '/cms/images/menu/noflash/'+name+'Over.png');
        } else {
             $(this).attr('src', '/cms/images/menu/noflash/'+name+'Over.png');
        }
    }, function(){
        name =  $(this).attr('picture');
        if(name==controller){
             $(this).attr('src', '/cms/images/menu/noflash/'+name+'Over.png');
        } else {
             $(this).attr('src', '/cms/images/menu/noflash/'+name+'.png');
        }
    });
}

function toMain() {
	$('#content').empty();
	$('#content').treeform( 'destroy' );
	$('#content').fields( 'destroy' );
	$('#content').editform( 'destroy' );
	$('#content').response( 'destroy' );
	$('#content').treecatalog( 'destroy' );
	$('#navigation').empty()
		.append(
			$('<a>')
				.attr('href', '/admin/')
				.text('Главная')
				.bind('click', function( event ) {
					toMain();
					return false;
				} )
		)
		.append(
			$('<span>')
				.attr('id', 'curmod' )
		)
	;
	var block = $('#content');
	$.ajax({
		url: '/content/back/index',
		type: 'get',
		dataType: 'json',
		error: function(){
			throw 'Error! Wrong JSON answer';
		},
		beforeSend: function(){
			block.append(
					$('<div></div>')
						.addClass('load'));
		},
		success: function( data ){
			block.html( data['text'] );
		}
	});
	flash = document.getElementById( 'main_flash' );
	if (flash.reset) flash.reset();
}

