class UsersController < ApplicationController
	before_action :require_user, only: [:edit, :update, :deactivate, :index]
	before_action :find_team, only: [:edit, :update, :index, :deactivate]
	before_action :find_team_to_join, only: [:new, :create, :activate]
	before_action :set_back_link, only: [:new, :create]
	before_action :set_back_user_panel_link, only: [:edit, :update, :index]
	
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

	def index 
		@team_members = current_user.team_members
	end

	def deactivate
		@user = @team.users.find_by(id: params[:id])
		if current_user == @user && @user && @user.deactivate!
			session[:user_id] = nil
			reset_session
			cookies.delete(:remember_me_token)
			flash[:alert] = 'Your account has been deactivated.'
			redirect_to new_team_path
		elsif current_user == @team.team_founder && @user && @user.deactivate!
			flash[:alert] = 'The account has been deactivated.'
			redirect_to team_users_path(@team)
		else
			flash[:alert] = 'Could not deactivate the account.'
			redirect_to team_users_path(@team)
		end
	end

	def activate
		@user = @team.users.find_by(id: params[:id])
		if current_user == @team.team_founder && @user && @user.activate!
			Notifier.send_activate_response(@user).deliver_now
			flash[:alert] = 'The account has been activated.'
			redirect_to team_users_path(@team)
		else
			flash[:alert] = 'Could not activate the account.'
			redirect_to team_users_path(@team)
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
