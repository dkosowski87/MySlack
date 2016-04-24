require 'rails_helper'

describe 'joining an existing team' do

	let!(:team) { create :team }

	def fill_and_submit(options={})
		options[:password] ||= 'welcome'
		visit '/'
		within('#join_team') do
			select 'Founders', from: 'id'
			fill_in 'Password', with: options[:password]
			click_button 'Join team'		
		end
	end
	
	it 'shows the create user page on success' do
		fill_and_submit
		expect(page).to have_content('Sign Up For Founders')
	end

	it 'shows the root page again with an message why we failed to join the team on failure' do
		fill_and_submit(password: 'wrong')
		expect(page).to have_content('Sorry')
		expect(page).not_to have_content('Sign Up For Founders')
	end
end