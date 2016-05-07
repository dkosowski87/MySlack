$(document).ready( function() {

	function parseMsg(response) {
		var html = "<div class='message'>" 
						+ "<a rel='no-follow' data-method='delete' href='/msgs/" + response.id + "'>"
						+ "<span class='delete-message-button'>&#10006;</span></a>"
						+ response.send_time
						+ "| <strong>"
						+ response.sender.name
						+ ":</strong> "
						+ "<span class='message-text'>" + response.content + "</span>"
						+ "</div>";
		return html	
	}

	function scrollView() {
		document.body.scrollTop = $('body').height();
	}

	scrollView();
	
	$('[href]').on("ajax:success", function(event, response) {
		var msgs = "";
		for (var i = 0; i < response.length; i += 1 ) {
			msgs += parseMsg(response[i]);
		}
		$('.top-menu').hide()
		$('.message-content').html(msgs).hide().fadeIn();
		scrollView();
		setTimeout(function () { $('.top-menu').fadeIn() }, 200);
		window.history.replaceState("", "", $(this).attr("href"));
		$('#search-form').attr("action", $(this).attr("href"));
	});

	$('#new_msg').on("ajax:success", function(event, response) {
		var msg = parseMsg(response);
		$('.message-content').append(msg);
		$('.message:last-child').hide().slideDown(200);
		$('#new_msg input[type="text"]').val("");
		$('body').animate({ scrollTop: $('body').height() }, 800);
	});

	$('#search-form').on("ajax:success", function(event, response) {
		var msgs = "";
		for (var i = 0; i < response.length; i += 1 ) {
			msgs += parseMsg(response[i]);
		}
		$('.message-content').html(msgs).hide().fadeIn();
		var searchedText = $('#search-form input[type="text"]').val();
		$('.message-text').each( function () {
			var messageText = $(this).html()
			var matchPhrase = new RegExp(searchedText, "gi")
			var matchedText = messageText.match(matchPhrase)[0]
			var foundText = messageText.replace(matchPhrase , "<span class='searched-text'>" + matchedText + "</span>");
			$(this).html(foundText);
		});
		scrollView();
		setTimeout(function () { $('.top-menu').fadeIn() }, 250);
	});

// Automatic msgs pulling (showing active channels and users)

});
 
