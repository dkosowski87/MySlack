require 'rails_helper'

describe 'creating a new team' do

	#When a visitor wants to create a team, he visits the root page and fills in a form
	
	def fill_in_and_submit(options={})
		attrs = attributes_for(:team).merge!(options)
		visit '/'
		expect(page).to have_content('Create a new team')
		within '#new_team' do
			fill_in 'Name', with: attrs[:name]
			fill_in 'Password', with: attrs[:password]
			fill_in 'Password confirmation', with: attrs[:password_confirmation]
			click_button 'Create team'	
		end
	end

	#After submitting the form:

	it 'creates a new team and redirects to sign up page on success' do
		fill_in_and_submit
		expect(Team.count).to eq(1)
		expect(page).to have_content('Sign Up For Founders')
	end

	it 'displays an error if the name of the team is not present' do 
		fill_in_and_submit(name: '')
		expect(Team.count).to eq(0)
		expect(page).to have_content("Please state the name of your team.")
	end

	it 'displays an error if the name of the team is shorter than 3 characters' do
		fill_in_and_submit(name: 'Fo')
		expect(Team.count).to eq(0)
		expect(page).to have_content("The name of your team should be between 3-15 characters")
	end

	it 'displays an error if the name of the team is longer than 15 characters' do
		fill_in_and_submit(name: 'Founders1234567890')
		expect(Team.count).to eq(0)
		expect(page).to have_content("The name of your team should be between 3-15 characters")
	end

	it 'displays an error if the name of the team is not in a proper format' do
		fill_in_and_submit(name: 'Founder$%#')
		expect(Team.count).to eq(0)
		expect(page).to have_content("Please use only letters and numbers. There can be whitespaces between words.")
	end

	it 'displays an error if the password is not present' do
		fill_in_and_submit(password: '')
		expect(Team.count).to eq(0)
		expect(page).to have_content(/can't be blank/)
	end

	it 'displays an error if the password does not match the password confirmation' do
		fill_in_and_submit(password_confirmation: 'hello')
		expect(Team.count).to eq(0)
		expect(page).to have_content(/doesn't match/)
	end

end
