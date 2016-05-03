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
		html += link_to " Yes, sure. |", "/teams/#{invitation.sender.team_id}/channels/#{template_info[0].to_i}/join", method: :patch
		html += link_to " No, thanks.", "/teams/#{invitation.sender.team_id}/channels/#{template_info[0].to_i}/reject", method: :patch
		return html.html_safe
	end

	#helpers for the filter menu

	def filter_months
		months_tag = capture {""}
		date = Date.new(1)
		1.upto(12) do
			query_string = {date: date.month}.to_query
			months_tag += capture do
				content_tag :li do
					link_to "#{date.strftime('%B')}", "during_month?#{query_string}"
				end 
			end
			date = date.next_month
		end
		months_tag
	end

	def filter_years
		years_tag = capture {""}
		year = Time.now.year
		5.times do
			query_string = {date: year}.to_query
			years_tag += capture do
				content_tag :li do
					link_to "#{year}", "during_year?#{query_string}"
				end 
			end
			year -= 1
		end
		years_tag
	end

end