class ChannelsController < ApplicationController
	before_action :require_user
	before_action :find_current_user_team
	before_action :find_user_channel, only: [:join, :reject, :unsubscribe]
	before_action :check_invitation_info, only: [:join, :reject]
	before_action :set_back_link
	
	def new
		@channel = current_user.adm_channels.new
	end

	def create
		@channel = current_user.adm_channels.new(channel_params)
		if @channel.save
			@team.channels << @channel
			redirect_to "/msgs/channel/#{@team.channels.first.id}/all"
		else
 			render 'new'
		end
	end

	def join
		if @channel && check_invitation_info
			@channel.users << current_user
			@invitation.accept!
			redirect_to "/msgs/channel/#{@channel.id}/all"
		else
			flash[:alert] = 'There is a problem with your invitation'
			redirect_to team_channels_path(@team)
		end
	end

	def reject
		if @channel && check_invitation_info
			@invitation.reject!
			redirect_to "/msgs/channel/#{@team.channels.first.id}/all"
		else
			flash[:alert] = 'There is a problem with your invitation'
			redirect_to team_channels_path(@team)
		end
	end

	def index
		@adm_channels = current_user.adm_channels
		@channels = current_user.channels
	end

	def unsubscribe
		if @channel && @channel.users.delete(current_user)
			redirect_to "/msgs/channel/#{@team.channels.first.id}/all"
		else
			flash[:alert] = "You did not unsubscribe from the channel"
			redirect_to team_channels_path(@team)
		end
	end

	def destroy
		@channel = current_user.adm_channels.find_by(id: params[:id])
		if @channel && @channel.destroy
			redirect_to "/msgs/channel/#{@team.channels.first.id}/all"
		else
			flash[:alert] = "The channel could not be deleted."
			redirect_to team_channels_path(@team)
		end
	end

	private
	def channel_params
		params.require(:channel).permit(:name)
	end

	def set_back_link
		go_back_link("/msgs/channel/#{@team.channels.first.id}/all")
	end

	def find_user_channel
		@channel = current_user.team.channels.find_by(id: params[:id])
	end

	def check_invitation_info
		@invitation = current_user.check_invitation(@channel)
	end

end