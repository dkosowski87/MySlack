module TeamHelpers
	def fill_in_create_team_form(options={})
		attrs = attributes_for(:team).merge!(options)
		visit '/'
		within '#new_team' do
			fill_in 'Name', with: attrs[:name]
			fill_in 'Password', with: attrs[:password]
			fill_in 'Password confirmation', with: attrs[:password_confirmation]
			click_button 'Create team'	
		end
	end
end