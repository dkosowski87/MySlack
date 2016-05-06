$(document).ready( function() {

	function parseMsg(response) {
		var html = "<div class='message'>" 
						+ "<a rel='no-follow' data-method='delete' href='/msgs/" + response.id + "'>"
						+ "<span class='delete-message-button'>&#10006;</span></a>"
						+ response.send_time
						+ "| <strong>"
						+ response.sender.name
						+ ":</strong> "
						+ response.content + 
						"</div>";
		return html	
	}

	$('#new_msg').on("ajax:success", function(event, response) {
		var msg = parseMsg(response)
		$('.message-content').append(msg);
		$('.message:last-child').hide().slideDown(200);
		$('#new_msg input[type="text"]').val("");
		$("body").animate({ scrollTop: $('body').height() }, 800);
	});

	$('[href]').on("ajax:success", function(event, response) {
		var msgs = "";
		for (var i = 0; i < response.length; i += 1 ) {
			msgs += parseMsg(response[i]);
		}
		$('.message-content').html(msgs).hide().fadeIn();
		window.history.replaceState("", "", $(this).attr("href"));
	});


// Automatic msgs pulling
// Searching through messages

});
 
