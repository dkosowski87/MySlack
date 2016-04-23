class MsgsController < ApplicationController
	before_action :require_user
	before_action :find_user
	before_action :find_team
	before_action :provide_message_template, only: [:index]

	def index
		case params[:type]
		when 'channel'
			if find_channel
				msgs_in_channel = Msg.in_channels(@channel)
				@msgs = filter_messages(msgs_in_channel, params[:q], params[:filter], params[:date])
				render layout: 'msgs_panel'
			else
				render file: 'public/404', status: :not_found
			end
		when 'user'
			if find_team_member
				msgs_between_team_members = Msg.between_team_members(current_user, @team_member)
				@msgs = filter_messages(msgs_between_team_members, params[:q], params[:filter], params[:date])
				render layout: 'msgs_panel'
			else
				render file: 'public/404', status: :not_found
			end
		end 		
	end

	def create
		@msg = current_user.sent_msgs.new(msg_params)
		if @msg.save
		 	redirect_to "/msgs/#{params[:msg][:recipient_type].downcase}/#{params[:msg][:recipient_id]}/all" 
		else
			flash[:alert] = "The message was not sent"
			redirect_to "/msgs/channel/#{current_user.team.channels.first.id}/all"
		end
	end

	def destroy
		@msg = current_user.sent_msgs.find_by(id: params[:id])
		if @msg.destroy
			redirect_to "/msgs/channel/#{current_user.team.channels.first.id}/all"
		else
			flash[:alert] = "The message was not destroyed"
			redirect_to "/msgs/channel/#{current_user.team.channels.first.id}/all"	
		end
	end

	private

	def msg_params
		params.require(:msg).permit(:content, :recipient_type, :recipient_id)
	end

	def find_user
		@user = current_user
	end

	def find_channel
		@channel = current_user.channels.find_by(id: params[:id])
	end

	def find_team_member
		@team_member = current_user.team.users.find_by(id: params[:id])
	end

	def provide_message_template
		@msg = Msg.new
	end

	def filter_messages(msgs, search_text, filter, date=nil)
		searched_msgs = msgs.with_text(search_text)
		case filter
		when 'today'
			searched_msgs.today
		when 'yesterday'
			searched_msgs.yesterday
		when 'this_week'
			searched_msgs.this_week
		when 'last_week'
			searched_msgs.last_week
		when 'during_year'
			searched_msgs.during_year(date)
		when 'during_month'
			searched_msgs.during_month(date)
		else
			searched_msgs
		end
	end

end