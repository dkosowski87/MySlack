class TeamsController < ApplicationController
	before_filter :require_user, only: [:destroy]

	def new
		@team = Team.new		
	end

	def create
		@team = Team.new(team_params)
		if @team.save
			redirect_to new_team_team_founder_path(@team)
		else
			render 'new'
		end
	end

	def join
		@team = Team.find(params[:id])
		if @team && @team.authenticate(params[:password])
			redirect_to new_team_user_path(@team)
		else
			flash[:alert] = "Sorry, incorrect password."
			redirect_to new_team_path
		end
	end

	def destroy
		@team = current_user.team
		if @team.team_founder == current_user
			@team.destroy
			redirect_to new_team_path
		else
			flash[:alert] = "Could not delete team"
			redirect_to "/msgs/channel/#{@team.channels.first.id}/all"
		end
	end

	private
	def team_params
		params.require(:team).permit(:name, :password, :password_confirmation)
	end
end
