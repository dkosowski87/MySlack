class SessionsController < ApplicationController
	before_action :set_back_link

	def new
	end

	def create
		user = User.find_by(email: params[:email])
		if user && user.authenticate(params[:password])
			if params[:remember_me]
				cookies.permanent.encrypted[:remember_me_token] = user.id
			end
			session[:user_id] = user.id
			redirect_to "/msgs/channel/#{user.team.channels.first.id}/all"
		else
			flash.now[:alert] = "Incorrect Email or Password"
			render 'new'
		end
	end

	def destroy
		session[:user_id] = nil
		reset_session
		cookies.delete(:remember_me_token)
		redirect_to new_team_path
	end

	private
	def set_back_link
		go_back_link(new_team_path)
	end

end
