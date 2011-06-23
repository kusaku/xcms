function incCount(id){
	var count = $("#count"+id).val();
	count++;
	$("#count"+id).val(count);
}

function decCount(id){
	var count = $("#count"+id).val();
	if (count > 1) count--;
	$("#count"+id).val(count);
}

function summaStepOne(){
	$("#shopCart").html($('#cart_summ').html());
}

function summaStepTwo(){
	var summ = 0;

	$("#delivery").html( parseInt($('input[name=shop_order_delivery]:checked').attr('price')) );
	summ = parseInt($("#summ").val()) + parseInt($('input[name=shop_order_delivery]:checked').attr('price'));

	$("#totalSumm").html(summ);
}

function addToOrder(path, id){
	$("#btn"+id).addClass('cartbtn2');
	$("#btn"+id).removeClass('cartbtn');
	$.ajax({
		url:path,
		data:{'ajax': true,
				'add_to_order': true},
		dataType: 'html',
		success: function(data){
			$('#myCart').replaceWith(data);
		}
	});
}

function delFromOrder(path ,id){
	$('#tr'+id).replaceWith('');
	$("#btn"+id).removeClass('cartbtn2');
	$("#btn"+id).addClass('cartbtn');
	
	$.ajax({
		url:path,
		data:{'ajax': true,
				'delete_from_order': 1},
		dataType: 'html',
		success: function(data){
			$('#myCart').replaceWith(data);
			summaStepOne();
		}
	});
}