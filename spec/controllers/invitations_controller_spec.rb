require 'rails_helper'

RSpec.describe InvitationsController do

	let!(:team) { create(:team) }
	let!(:user) { create(:user) }

	describe 'GET #new' do
		context 'if the user is not logged in'do
			it 'redirects to login_path' do
				get :new
				expect(response).to redirect_to(login_path)
			end
		end

		context 'if the user is logged in' do

			before(:each) do
				allow(controller).to receive(:current_user).and_return(user)	
				get :new
			end

			it 'responds with an http success status' do
				expect(response).to be_successful
				expect(response).to have_http_status(200)
			end

			it 'assigns a new invitation instance variable sent by the current user' do
				expect(assigns(:invitation)).to be_a_new(Invitation)
				expect(assigns(:invitation).sender).to eq(user)
			end

			it 'assigns the user team members to an instance variable' do
				expect(assigns(:team_members)).to eq(user.team_members)
			end

			it 'assigns the user adm channels to an instance variable' do
				expect(assigns(:adm_channels)).to eq(user.adm_channels)
			end

			it 'renders the new template' do
				expect(response).to render_template('new')
			end
		end	 
	end

	describe 'POST #create' do

		let!(:channel) { user.adm_channels.create(name: 'Fun', team_id: user.team_id) }
		let!(:team_member) { create(:team_member, team_id: user.team_id) }

		before(:each) do
			allow(controller).to receive(:current_user).and_return(user)
		end

		def valid_params(options={})
			{ channel_id: channel.id, invitation: { content: 'This is a test invitation', recipient_id: team_member.id } }.
			merge!(options)
		end
		
		it 'finds the channel for which the invitation is sent' do
			expect(user.adm_channels).to receive(:find_by).and_return(channel)
			post :create, valid_params
		end

		it 'creates the invitation' do
			expect { post :create, valid_params }.to change(Invitation, :count).by(1)
		end

		it 'appends the channel id to the message body' do
			post :create, valid_params
			expect(Invitation.last.content).to match(/#\d+/)
		end	

		it 'redirect to recipient msgs page' do
			post :create, valid_params
			expect(response).to redirect_to("/msgs/user/#{valid_params[:invitation][:recipient_id]}/all")
		end

		it 'renders the new page again on failure' do
			post :create, valid_params(invitation: {content: ""})
			expect(response).to render_template('new')
		end
	end
end