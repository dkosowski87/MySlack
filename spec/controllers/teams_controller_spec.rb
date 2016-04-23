require 'rails_helper'

RSpec.describe TeamsController do

	describe 'GET #new' do

		before(:example) do
			get :new
		end

		it 'responds successfully with a HTTP 200 status code' do	
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end

		it 'renders the new template' do
			expect(response).to render_template('new')
		end

		it 'provides a team instance variable to the view' do
			expect(assigns(:team)).to be_a_new(Team)
		end

	end

	describe 'POST #create' do

		def post_params(options={})
			attributes_for(:team).merge!(options)
		end

		context 'with valid attributes' do
			it 'creates a team' do
		  	post :create, team: post_params
		  	expect(Team.count).to eq(1)
			end	

			it 'redirects to new user path' do
				post :create, team: post_params
				team = Team.last
		  	expect(response).to redirect_to(new_team_user_path(team))
			end	
		end

		context 'with invalid attributes'do
			it 'does not create the team' do
				post :create, team: post_params(name: '')
				expect(Team.count).to eq(0)
			end

			it 'renders the new action' do
				post :create, team: post_params(name: '')
				expect(response).to render_template('new')
			end	
		end
		
	end
end