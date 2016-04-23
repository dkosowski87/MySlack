class UsersController < ApplicationController
	before_action :require_user, only: [:show]
	before_action :find_team, only: [:edit, :update]
	before_action :find_team_to_join, only: [:new, :create]
	before_action :set_back_link, only: [:new, :create]
	before_action :set_back_user_panel_link, only: [:edit, :update]
	
	def new
		@user = @team.users.new		
	end

	def create
		@user = @team.users.new(user_params)
		if @user.save
			session[:user_id] = @user.id
			Notifier.welcome(@user).deliver_now
			redirect_to "/msgs/channel/#{@user.team.channels.first.id}/all"
		else
			render 'new'
		end
	end

	def edit
		@user = current_user
	end

	def update
		@user = current_user
		if @user.update(user_params)
			redirect_to "/msgs/channel/#{@team.channels.first.id}/all"
	  else
	  	flash.now[:alert] = "Could not change user information"
	  	render 'edit'
	  end
	end

	private
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation)
	end

	def find_team_to_join
		@team = Team.find_by(id: params[:team_id])
	end

	def set_back_link
		go_back_link(new_team_path)
	end

	def set_back_user_panel_link
		go_back_link("/msgs/channel/#{@team.channels.first.id}/all")
	end

end
