require 'rails_helper'

RSpec.describe 'teams/new' do

	before(:each) do
		assign(:team, Team.new)
		render
	end

	it 'renders the new_team form' do
		expect(rendered).to have_selector('#new_team')
	end

	it 'renders the join team form' do
		expect(rendered).to have_selector('#join_team')
	end

	it 'displays a link to the login path' do
		expect(rendered).to have_content('Already working with MySlack? Sign In.')
	end
end