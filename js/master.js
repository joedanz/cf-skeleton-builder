$(document).ready(function(){
	$('div#container').corner();
	$('div#header').corner();
	$('div.row').corner();
	showTables()
	$('input, textarea, select').focus(function(){ $(this).css('background-color', '#ffc'); });
	$('input, textarea, select').blur(function(){ $(this).css('background-color', '#fff'); });
	$('#appName').focus();
});

function showTables() {
	if ($('#dsource').val() == '') {
		$('#step8').hide();	
	} else $('#step8').show();
}

