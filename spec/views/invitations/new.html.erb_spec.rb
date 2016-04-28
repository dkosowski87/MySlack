require 'rails_helper'

RSpec.describe 'invitations/new' do

	let!(:team) { create(:team) }
	let!(:user) { create(:user) }

	before(:each) do
		assign(:invitation, user.sent_invitations.new)
		assign(:team_members, user.team_members)
		assign(:adm_channels, user.adm_channels)
		render
	end

	it 'displays the send invitation title' do
		expect(rendered).to have_content('Create Your Invitation')
	end

	it 'displays the invitation form' do
		expect(rendered).to have_selector('form#new_invitation[method="post"]')
		expect(rendered).to have_selector('form#new_invitation[action="/invitations"]')
		expect(rendered).to have_selector('form textarea[name="invitation[content]"]')
		expect(rendered).to have_selector('form select[name="invitation[recipient_id]"]')
		expect(rendered).to have_selector('form select[name="channel_id"]')
	end

end