class ChannelsController < ApplicationController
	before_action :require_user
	before_action :find_team
	before_action :set_back_link
	
	def new
		@channel = Channel.new
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
		check_invitation
		if @channel && @invitation
			@channel.users << current_user
			@invitation.accept!
			redirect_to "/msgs/channel/#{@channel.id}/all"
		else
			render 'new'
			@channel = Channel.new
			flash.now[:alert] = 'There is a problem with your invitation'
		end
	end

	def reject
		check_invitation
		if @channel && @invitation
			@invitation.reject!
			redirect_to "/msgs/channel/#{@team.channels.first.id}/all"
		else
			render 'new'
			@channel = Channel.new
			flash.now[:alert] = 'There is a problem with your invitation'
		end
	end

	private
	def channel_params
		params.require(:channel).permit(:name)
	end

	def set_back_link
		go_back_link("/msgs/channel/#{@team.channels.first.id}/all")
	end

	def check_invitation
		@channel = current_user.team.channels.find_by(id: params[:id])
		@invitation = current_user.received_invitations.where(sender: @channel.admin, state: 'pending').with_text("##{@channel.id}").last
	end
end