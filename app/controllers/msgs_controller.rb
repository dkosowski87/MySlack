class MsgsController < ApplicationController
	before_action :require_user
	before_action :find_user
	before_action :find_current_user_team
	before_action :provide_message_template, only: [:index]

	def index
		if params[:type] == 'channel'&& find_channel
			msgs_in_channel = Msg.in_channels(@channel)
			@msgs = find_messages(msgs_in_channel)
			respond_to_index_request
		elsif params[:type] == 'user' && find_team_member
			msgs_between_team_members = Msg.between_team_members(current_user, @team_member)
			@msgs = find_messages(msgs_between_team_members)
			respond_to_index_request
		else
			render file: 'public/404', status: :not_found
		end
	end

	def create
		@msg = current_user.sent_msgs.new(msg_params)
		respond_to do |format|
			if @msg.save
				if request.xhr?
					format.json { render json: @msg }
				else
					format.html { redirect_to "/msgs/#{params[:msg][:recipient_type].downcase}/#{params[:msg][:recipient_id]}/all" }
				end
			else
				flash[:alert] = "The message was not sent"
				format.html { redirect_to "/msgs/channel/#{current_user.team.channels.first.id}/all" }
			end
		end
	end

	def destroy
		@msg = current_user.sent_msgs.find_by(id: params[:id])
		if @msg.destroy
			redirect_to "/msgs/#{@msg.recipient_type.to_s.downcase}/#{@msg.recipient_id}/all"
		else
			flash[:alert] = "The message was not destroyed"
			redirect_to "/msgs/#{@msg.recipient_type.to_s.downcase}/#{@msg.recipient_id}/all"	
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

	def find_messages(msgs)
		filter_messages(msgs, params[:q], params[:filter], params[:date]).order(:created_at)
	end

	def respond_to_index_request
		respond_to do |format|
			if request.xhr?
				format.json { render json: @msgs }
			else
				format.html { render layout: 'msgs_panel' }
			end
		end
	end

end