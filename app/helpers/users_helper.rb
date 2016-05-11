module UsersHelper	

	#helpers for the team_menu

	def recipient_groups(group, user)
		unless group.empty?
			members_tag = capture {""}
			content_tag :ul, class: 'nested vertical menu' do		
				group.each do |member|
					members_tag += capture { generate_recipient_tag(member) }
				end
				members_tag
			end
		end
	end

	def generate_recipient_tag(member)
		type = member.class.to_s == 'Channel' ? 'channel' : 'user'
		link_to "/msgs/#{type}/#{member.id}/all", remote: true do
			content_tag :li, class: "#{type}" do
				content_tag(:i, " ", class: "fi-#{group_icon(member)}") + content_tag(:span, member.name)
			end
		end
	end

	def group_icon(member)
		case member.class.to_s
		when 'User', 'TeamFounder'
			'torso'
		when 'Channel'
			'volume'
		end	
	end	

end