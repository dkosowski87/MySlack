require 'rails_helper'

RSpec.describe 'creating a user' do |variable|

	let!(:team) { create(:team) }

	def fill_in_and_submit(options={})
		attrs = attributes_for(:user).merge!(options)
		visit "teams/#{team.id}/users/new"
		fill_in 'Name', with: attrs[:name]
		fill_in 'Email', with: attrs[:email]
		fill_in 'Password', with: attrs[:password]
		fill_in 'Password confirmation', with: attrs[:password_confirmation]
		click_button 'Sign up'
	end
 	
 	it 'redirects to user panel on success' do
 		fill_in_and_submit
 		expect(page).to have_content('Create a Channel +')
 	end

 	it 'sends a welcome email to the user on success' do
 		fill_in_and_submit
 		welcome_email = ActionMailer::Base.deliveries.last
 		expect(welcome_email.to).to eq([User.last.email])
 	end 
 	
 	it 'displays an error if the name of the user is not present' do
 		fill_in_and_submit(name: '')
 		expect(page).to have_content("Please state your name.")
 	end

 	it 'displays an error if the name of the user is in downcase present' do
 		fill_in_and_submit(name: 'john')
 		expect(page).to have_content("Your name should start with an uppercase letter.")
 	end

 	it 'displays an error if the email of the user is not present' do
 		fill_in_and_submit(email: '')
 		expect(page).to have_content("Please enter your email.")
 	end

 	it 'displays an error if the email is not properly formatted' do
 		fill_in_and_submit(email: 'johnexample.com')
 		expect(page).to have_content("The email has an improper format.")
 	end

 	it 'displays an error if the email has been taken' do
 		user = create(:user)
 		fill_in_and_submit
 		expect(page).to have_content("This email has already been taken.")
 	end

 	it 'displays an error if the password is not present' do
 		fill_in_and_submit(password: '')
 		expect(page).to have_content(/can't be blank/)
 	end

 	it 'displays an error if the password and password confirmation do not match' do
 		fill_in_and_submit(password_confirmation: 'hello')
 		expect(page).to have_content(/doesn't match/)
 	end	
end

