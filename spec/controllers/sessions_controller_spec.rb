require 'rails_helper'

RSpec.describe SessionsController do
	describe 'GET #new' do
		it 'returns a http success status' do
			get :new
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end
	 	it 'renders the sessions/new template' do
	 		get :new
	 		expect(response).to render_template('new')
	 	end
	end

	describe 'POST #new' do

		let!(:user) { create(:user)}

		def user_params(options={})
			attributes_for(:user).
			merge!(options).
			select { |attr_name, value| attr_name.in? [:email, :password] }
		end
		
		it 	'finds the user by email' do
			expect(User).to receive(:find_by).with(email: user.email)
			post :create, user_params
		end

		it 'authenticates the user by password' do
			allow(User).to receive(:find_by).with(email: user.email).and_return(user)
			expect(user).to receive(:authenticate)
			post :create, user_params
		end

		context 'with valid params' do
			it 'redirects to the users message index path' do
				post :create, user_params
				expect(response).to be_a_redirect
				expect(response).to redirect_to("/msgs/channel/#{user.team.channels.first.id}/all")
			end
			it 'creates a session for the current user' do
				post :create, user_params
				expect(session[:user_id]).to eq(user.id)
			end
		end
			
		context 'with invalid params' do
			it 'renders the new template again' do
				post :create, user_params(password: 'wrong')
				expect(response).to render_template('new')
			end
			it 'creates a flash a message' do
				post :create, user_params(password: 'wrong')
				expect(flash.now[:alert]).to eq('Incorrect Email or Password')
			end
		end
	end		
end