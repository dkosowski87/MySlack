require 'rails_helper'

describe 'creating a session' do

	let!(:team) { create(:team) }
	let!(:user) { create(:user) }
	
	def fill_and_submit(options={})
		attrs = attributes_for(:user).merge!(options)
		visit '/'
		click_link('Already working with MySlack? Sign In.')
		fill_in 'Email', with: attrs[:email]
		fill_in 'Password', with: attrs[:password]
		click_button 'Sign in'		
	end

	it 'shows the user panel if the login is successful' do
		fill_and_submit
		expect(page).to have_content('Create a Channel +')
	end

	it 'shows the login page again after an unsuccessful login' do
		fill_and_submit(password: 'wrong')
		expect(page).to have_content('Sign In To Your Account')
	end

	it 'displays an explanatory message after an unsuccessful login' do
		fill_and_submit(password: 'wrong')
		expect(page).to have_content('Incorrect Email or Password')
	end

end
	