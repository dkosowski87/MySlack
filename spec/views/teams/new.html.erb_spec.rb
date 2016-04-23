require 'rails_helper'

RSpec.describe 'teams/new' do
	it 'renders the new_team form' do
		assign(:team, Team.new)
		render
		expect(rendered).to have_selector('form')
		expect(rendered).to have_selector('#new_team')
	end
end