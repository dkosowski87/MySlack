require 'rails_helper'

describe 'creating and sending invitations' do
	let!(:team) { create(:team) }
	let!(:user) { create(:user) }
  let!(:channel) { user.adm_channels.create(name: 'Fun', team_id: user.team_id) }
  let!(:team_member) { create(:team_member, team_id: user.team_id) }

	def fill_in_and_submit(options={})
    options[:invitation_content] ||= 'This is a test invitation'
    sign_in_team_user
    click_link 'Send Invitation +'
    fill_in 'invitation[content]', with: options[:invitation_content]
    select 'Jim', from: 'Team Member'
    select 'Fun', from: 'Channel'
    click_button 'Send Invitation'
  end

  it 'displays the invitation message in the message view on success' do
    fill_in_and_submit
    expect(page).to have_content("You have sent an invitation to Jim")
    expect(page).to have_content("Send Invitation +")
  end

  it 'displays the create invitation page with a msg about the problem on failure' do
    fill_in_and_submit(invitation_content: "")
    expect(page).to have_content("You are trying to send a message without any content.")
    expect(page).to have_content('Create Your Invitation')
  end
  
end

