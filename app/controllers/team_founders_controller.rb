class TeamFoundersController < ApplicationController
	before_action :require_user, only: [:edit, :update]
	before_action :find_team
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
			redirect_to "/msgs/channel/#{@team.channels.first.id}/all"
		else
			render 'new'
		end
	end

	def edit
		if @team && @team.team_founder == current_user
			@team_founder = current_user
		else
			render_file_not_found
		end
	end

	def update
		if @team && @team.team_founder == current_user
			@team_founder = current_user
			if @team_founder.update(user_params)
				redirect_to "/msgs/channel/#{@team.channels.first.id}/all"
	  	else
	  		flash.now[:alert] = "Could not change user information"
	  		render 'edit'
	  	end
	  else
			render_file_not_found
	  end
	end

	private
	def user_params
		params.require(:team_founder).permit(:name, :email, :password, :password_confirmation)
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