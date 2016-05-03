class TeamsController < ApplicationController
	before_filter :require_user, only: [:destroy]
	before_filter :find_team, only: [:join, :destroy]

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
		if @team && @team.authenticate(params[:password])
			cookies.encrypted[:pass] = params[:password]
			redirect_to new_team_user_path(@team)
		else
			flash[:alert] = "Sorry, incorrect password."
			redirect_to new_team_path
		end
	end

	def destroy
		if @team && @team.team_founder == current_user
			@team.destroy
			redirect_to new_team_path
		else
			flash[:alert] = "Could not delete team."
			redirect_to new_team_path
		end
	end

	private
	def team_params
		params.require(:team).permit(:name, :password, :password_confirmation)
	end
	
	def find_team
		@team = Team.find_by(id: params[:id])
	end

end
