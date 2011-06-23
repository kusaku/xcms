$(function() {
        $('#text').find('input:submit').button();
	$('#content').find('input:submit').button();
	$('#content').find('input[type=checkbox]')
		.not('.viewcheckbox')
		.not('.editcheckbox').checkbox();
	var params = {
			changedEl: "#content select",
			visRows: 5,
			scrollArrows: true
	};
	cuSel(params);
} );

/*$(document).ready(function() {
        $("#installStep").validate({
		rules: {
                    license_agree: "required"
                },
                messages: {}
        });
});*/