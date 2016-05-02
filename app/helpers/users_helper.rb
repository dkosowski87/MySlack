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
		link_to "/msgs/#{type}/#{member.id}/all" do
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