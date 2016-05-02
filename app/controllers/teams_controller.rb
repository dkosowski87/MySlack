class TeamsController < ApplicationController
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

	private
	def team_params
		params.require(:team).permit(:name, :password, :password_confirmation)
	end
end
