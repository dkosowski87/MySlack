$(document).ready( function() {

	function createMsgTemplate(message) {
		var html = "<div class='message'>" 
						+ "<a rel='no-follow' data-method='delete' href='/msgs/" + message.id + "'>"
						+ "<span class='delete-message-button'>&#10006;</span></a>"
						+ message.send_time
						+ "| <strong>"
						+ message.sender.name
						+ ":</strong> "
						+ "<span class='message-text'></span>"
						+ "</div>";
		return html	
	}

	$('#new_msg').on("ajax:success", function(event, response) {
		var msgTemplate = createMsgTemplate(response);
		$('.message-content').append(msgTemplate);
		$('.message:last-child .message-text').text(response.content);
		$('.message:last-child').hide().slideDown(200);
		$('#new_msg input[type="text"]').val("");
		$('body').animate({ scrollTop: $('body').height() }, 800);
	});

	function scrollView() {
		$('.top-menu').hide();
		$('.message-container').hide().fadeIn();
		document.body.scrollTop = $('body').height();
		setTimeout(function () { $('.top-menu').fadeIn() }, 200);
	}

	function toggleActiveLinks(element) {
		if ( element.parent().attr('role') === 'menuitem') {
			$('[role="menuitem"]').removeClass('active');
			element.parent().addClass('active');
		} else {
			$('li').removeClass('active-link');
			$('li').removeClass('active');
			element.children().first().addClass('active-link');
		}	
	}
	
	$('[href]').on("ajax:success", function(event, response) {
		var newPath = $(this).attr("href");
		window.history.replaceState("", "", newPath);
		var pathArray = window.location.pathname.split('/');
		
		$('#search-form').attr("action", newPath);	
		$('#msg_recipient_type').val(pathArray[2].charAt(0).toUpperCase() + pathArray[2].slice(1));
		$('#msg_recipient_id').val(pathArray[3]);

		toggleActiveLinks($(this));

		$('.message-container').html(response);
		scrollView();
	});

	$('#search-form').on("ajax:success", function(event, response) {
		var searchedText = $('#search-form input[type="text"]').val();

		$('.message-container').html(response)

		$('.message-text').each( function () {
			var messageText = $(this).text()
			var matchPhrase = new RegExp(searchedText, "gi")
			var matchedText = messageText.match(matchPhrase)[0]
			var foundText = messageText.replace(matchPhrase , "<span class='searched-text'>" + matchedText + "</span>");
			$(this).html(foundText);
		});	
		scrollView();
	});

	$('.channel').first().addClass('active-link');
	$('#refresh-link').hide();
	scrollView();


});
 
