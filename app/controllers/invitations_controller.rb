class InvitationsController < ApplicationController
	before_action :require_user
	before_action :find_team_members
	before_action :find_team
	before_action :set_back_link

	def new
		@invitation = current_user.sent_invitations.new
		@adm_channels = current_user.adm_channels
	end

	def create
		@invitation = current_user.sent_invitations.new(invitation_params)
		if @invitation.valid?
			channel = current_user.adm_channels.find_by(id: params[:channel_id])
			params[:invitation][:content] += " ##{channel.id} #{channel.name}"
			@invitation = current_user.sent_invitations.new(invitation_params)
			@invitation.save
			redirect_to "/msgs/user/#{params[:invitation][:recipient_id]}/all"
		else
			@adm_channels = current_user.adm_channels
			render 'new'
		end
	end

	private
	def invitation_params
		params.require(:invitation).permit(:content, :recipient_id)
	end

	def find_team_members
		@team_members = current_user.team_members
	end

	def set_back_link
		go_back_link("/msgs/channel/#{@team.channels.first.id}/all")
	end

end