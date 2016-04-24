require 'rails_helper'

RSpec.describe 'teams/new' do
	it 'renders the new_team form' do
		assign(:team, Team.new)
		render
		expect(rendered).to have_selector('#new_team')
	end

	it 'renders the join team form' do
		assign(:team, Team.new)
		render
		expect(rendered).to have_selector('#join_team')
	end
end