require 'rails_helper'

describe 'creating a session' do

	let!(:team) { create(:team) }
	let!(:user) { create(:user) }

	it 'shows the user panel if the login is successful' do
		sign_in_team_user
		expect(page).to have_content('Create a Channel +')
	end

	it 'shows the login page again after an unsuccessful login' do
		sign_in_team_user(password: 'wrong')
		expect(page).to have_content('Sign In To Your Account')
	end

	it 'displays an explanatory message after an unsuccessful login' do
		sign_in_team_user(password: 'wrong')
		expect(page).to have_content('Incorrect Email or Password')
	end

end
	