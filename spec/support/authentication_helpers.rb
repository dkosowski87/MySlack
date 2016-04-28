module AuthenticationHelpers

	def sign_in_team_user(options={})
		attrs = attributes_for(:user).merge!(options)
		visit '/'
		click_link('Already working with MySlack? Sign In.')
		fill_in 'Email', with: attrs[:email]
		fill_in 'Password', with: attrs[:password]
		click_button 'Sign in'		
	end

end