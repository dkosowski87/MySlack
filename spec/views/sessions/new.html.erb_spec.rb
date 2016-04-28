require 'rails_helper'

RSpec.describe 'sessions/new' do

	it 'diplays the sign up text' do
		render
		expect(rendered).to have_content('Sign In To Your Account')
	end

	it 'diplays the login form' do
		render
		expect(rendered).to have_selector('form#login')
	end
end