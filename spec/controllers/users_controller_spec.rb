require 'rails_helper'

RSpec.describe UsersController do

	let!(:team) { create(:team) }

	describe 'GET #new' do

		before(:example) do		
			get :new, { team_id: team.id }
		end

		it 'responds with an HTTP success message' do
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
	
		it 'renders the new template' do
			expect(response).to render_template('new')
		end

	  it 'provides the specified team instance variable to the view' do
		 	expect(assigns(:team)).to eq(team)
		 end

		it 'provides a new user instance variable to the view' do
			expect(assigns(:user)).to be_a_new(User)
			expect(assigns(:user).team_id).to eq(team.id)
		end
	end

	describe 'POST #create' do

		def valid_params(options={})
			attrs = attributes_for(:user).merge!(options)
		 	params = { team_id: team.id, 
				user: { name: attrs[:name], 
					      email: attrs[:email], 
								password: attrs[:password], 
								password_confirmation: attrs[:password_confirmation] 
				}
			}
		end

		def invalid_params
			valid_params(name: '')
		end

		context 'with valid params' do
 
			it 'creates a user' do
				post :create, valid_params
				expect(User.count).to eq(1)
			end

			it 'sends an email to the created user on success' do
				expect { post :create, valid_params }.to change(ActionMailer::Base.deliveries, :size).by(1)
 			end 

			it 'redirects to user panel' do
				post :create, valid_params
				expect(response).to redirect_to("/msgs/channel/#{team.channels.first.id}/all")
			end	
		end
			
		context 'with invalid params' do

			it 'does not create a user' do
				post :create, invalid_params
				expect(User.count).to eq(0)
			end

			it 'does not send an email' do
				expect { post :create, invalid_params }.not_to change(ActionMailer::Base.deliveries, :size)
			end
			
		  it 'renders the new template' do
		  	post :create, invalid_params
		  	expect(response).to render_template('new')
		  end
		end		 
	end
end