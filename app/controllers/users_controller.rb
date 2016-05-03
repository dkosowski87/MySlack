class UsersController < ApplicationController
	before_action :require_user, only: [:edit, :update, :deactivate, :index]
	before_action :find_team, only: [:new, :create, :index, :deactivate, :activate]
	before_action :find_current_user_team, only: [:edit, :update ]
	before_action :set_back_link, only: [:new, :create]
	before_action :set_back_user_panel_link, only: [:edit, :update, :index]
	
	def new
		@user = @team.users.new		
	end

	def create
		@user = @team.users.new(user_params)
		if @team && @team.authenticate(cookies.encrypted[:pass])
			if @user.save
				session[:user_id] = @user.id
				Notifier.welcome(@user).deliver_now
				cookies.delete(:pass)
				redirect_to "/msgs/channel/#{@user.team.channels.first.id}/all"
			else
				render 'new'
			end
		else
			flash.now[:alert] = 'You do not have access to this team.'
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
		if @team && @team.team_founder == current_user
			@team_members = current_user.team_members
		else
			render_file_not_found
		end
	end

	def deactivate
		@user = @team.users.find_by(id: params[:id])
		if @user && @user == current_user && @user.deactivate!
			session[:user_id] = nil
			reset_session
			cookies.delete(:remember_me_token)
			flash[:alert] = 'Your account has been deactivated.'
			redirect_to new_team_path
		elsif @user && @team.team_founder == current_user && @user.deactivate!
			flash[:alert] = 'The account has been deactivated.'
			redirect_to team_users_path(@team)
		else
			flash[:alert] = 'Could not deactivate the account.'
			redirect_to team_users_path(@team)
		end
	end

	def activate
		@user = @team.users.find_by(id: params[:id])
		if @user && @team.team_founder == current_user && @user.activate!
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

	def find_team
		@team = Team.find_by(id: params[:team_id])
	end

	def set_back_link
		go_back_link(new_team_path)
	end

	def set_back_user_panel_link
		go_back_link("/msgs/channel/#{@team.channels.first.id}/all")
	end

end
