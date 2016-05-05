// Sending messages
/* When the user submits the new_message form
 1) We send a request to the browser to save the message
 2) We retrieve the messages
 3) We append it to the end of the message view
 4) We push the whole msgs view upwards to see the last message
 */

$(document).ready( function() {

	$('#new_msg').on("ajax:success", function(event, response) {
		var $html = $("<div class='message'>" 
						+ "<a rel='no-follow' data-method='delete' href='/msgs/" + response.id + "'>"
						+ "<span class='delete-message-button'>&#10006;</span></a>"
						+ response.send_time
						+ "| <strong>"
						+ response.sender.name
						+ ":</strong> "
						+ response.content + 
						"</div>");

		$('.message-content').append($html);
		$('.message:last-child').hide().slideDown(200);
		$('#new_msg input[type="text"]').val("");
		$("body").animate({ scrollTop: $('body').height() }, 800);
	});

});
 