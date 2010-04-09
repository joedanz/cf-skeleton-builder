$(document).ready(function(){
	$('div#container').corner("bottom");
	$('div#header').corner();
	$('div.row').corner();
	showTables();
	$('#appName').focus();
});

function showTables() {
	if ($('#dsource').val() == '') {
		$('#step9').hide();
	} else $('#step9').show();

	$.ajax({
	  url: 'ajax/getTables.cfm',
	  data: 'ds=' + $('#dsource').val(),
	  success: function(data) {
	    $('#tables').html(data);
	  }
	});

}

