class SessionsController < ApplicationController
	before_action :set_back_link

	def new
	end

	def create
		user = User.find_by(email: params[:email])
		if user && user.authenticate(params[:password])
			if user.state == 'active'
				if params[:remember_me]
					cookies.permanent.encrypted[:remember_me_token] = user.id
				end
				reset_session
				session[:user_id] = user.id
				redirect_to "/msgs/channel/#{user.team.channels.first.id}/all"
			else
				Notifier.send_activate_request(user).deliver_now
				flash.now[:alert] = "Your account is deactivated. 
				An information has been sent to your teams founder to activate the account.
				If your account will be activated, you will receive a proper email message."
				render 'new'
			end
		else
			flash.now[:alert] = "Incorrect Email or Password"
			render 'new'
		end
	end

	def destroy
		reset_session
		cookies.delete(:remember_me_token)
		redirect_to new_team_path
	end

	private
	def set_back_link
		go_back_link(new_team_path)
	end

end
