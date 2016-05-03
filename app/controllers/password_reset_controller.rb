class PasswordResetController < ApplicationController

	def new
		@user = User.new
		go_back_link(login_path)
	end

	def create
		@user = User.find_by(email: params[:email])
		if @user
			@user.generate_password_reset_token!
			Notifier.password_reset(@user).deliver_now
			flash[:alert] = 'A password reset token has been sent to your email adress'
			redirect_to login_path
		else
			flash.now[:alert] = 'Email not found'
			render 'new'
		end
	end

	def edit
		unless @user = User.find_by(password_reset_token: params[:password_reset_token])
	    render file: 'public/404.html', status: :not_found
	  end
	end

	def update
		@user = User.find_by(password_reset_token: params[:password_reset_token])
		if @user && @user.update(user_params)
			@user.update_attribute(:password_reset_token, nil)
			reset_session
			session[:user_id] = @user.id
			redirect_to "/msgs/channel/#{@user.team.channels.first.id}/all"
	  else
	  	flash.now[:alert] = "Could not change user information"
	  	render 'edit'
	  end
	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

end