require 'rails_helper'

RSpec.describe 'users/new' do

	let!(:team) { create(:team) }

	it 'has the expected teams title' do
		assign(:user, User.new)
		assign(:team, team )
		render
		expect(rendered).to have_content("Sign Up For #{team.name}")
	end

	it 'renders the new user form' do
		assign(:user, User.new)
		assign(:team, team )
		render
		expect(rendered).to have_selector("form.new_user")
	end
end