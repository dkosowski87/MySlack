module MsgsHelper

	def invitation_content(invitation)
		invitation.content.gsub(/#\d+ [A-Z][a-z]+/, '')
	end

	def parse_invitation(invitation)
		invitation.content.match(/#\d+ [A-Z][a-z]+/).to_s.delete('#').split(" ")
	end

	def join_channel_link(invitation)
		template_info = parse_invitation(invitation)
		html = "#{invitation.sender.name} is inviting you to join the <strong>#{template_info[1]}</strong> channel. Would you like to join?"
		html += link_to " Yes, sure. |", "/teams/#{invitation.sender.team_id}/channels/#{template_info[0].to_i}/join"
		html += link_to " No, thanks.", "/teams/#{invitation.sender.team_id}/channels/#{template_info[0].to_i}/reject"
		return html.html_safe
	end

end