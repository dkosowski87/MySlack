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

	private
	def channel_params
		params.require(:channel).permit(:name)
	end

	def set_back_link
		go_back_link("/msgs/channel/#{@team.channels.first.id}/all")
	end
end