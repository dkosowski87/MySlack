class TeamFoundersController < ApplicationController
	before_action :require_user, only: [:edit, :update]
	before_action :find_team_to_join, only: [:new, :create]
	before_action :find_team, only: [:edit, :update]
	before_action :set_back_link, only: [:new, :create]
	before_action :set_back_user_panel_link, only: [:edit, :update]
	
	def new
		@team_founder = @team.build_team_founder	
	end

	def create
		@team_founder = @team.build_team_founder(user_params)
		if @team_founder.save
			session[:user_id] = @team_founder.id
			Notifier.welcome(@team_founder).deliver_now
			redirect_to "/msgs/channel/#{@team_founder.team.channels.first.id}/all"
		else
			render 'new'
		end
	end

	def edit
		@team_founder = current_user
	end

	def update
		@team_founder = current_user
		if @team_founder.update(user_params)
			redirect_to "/msgs/channel/#{@team.channels.first.id}/all"
	  else
	  	flash.now[:alert] = "Could not change user information"
	  	render 'edit'
	  end
	end

	private
	def user_params
		params.require(:team_founder).permit(:name, :email, :password, :password_confirmation)
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