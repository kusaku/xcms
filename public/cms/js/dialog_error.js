$(function() {
	$("#dialog-confirm").dialog("destroy");
	$("#dialog-confirm").dialog({
		autoOpen: false,
		minHeight: 97,
		width: 250,
		resizable: false,
		modal: true,
		buttons: {
			'Ок': function() {
				$(this).dialog('close');
				$('#dialog-confirm').remove();
			}
		},
		close: function() {
			$('#dialog-confirm').remove();
		}
	});
	$('#dialog-confirm').dialog('open');
});