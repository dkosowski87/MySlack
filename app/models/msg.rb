class Msg < ActiveRecord::Base
#Associations	
	belongs_to :sender, class_name: "User", foreign_key: "sender_id"
	belongs_to :recipient, polymorphic: true

#Validations
	validates :sender_id, presence: true
	validates :recipient_id, presence: {message: "Please enter the recipient of the messages."}
	validates :recipient_type, presence: {message: "Please enter the type of recipient."}
	validates :content, presence: {message: "You are trying to send a message without any content."},
											length: {maximum: 2000, message: "Your message is too long."}
	validate :addressed_properly?, if: "recipient_id.present? && recipient_type.present?"

	def addressed_properly?
		case recipient_type
		when "Channel"
			if !(User.find(sender_id).channels.ids.include?(recipient_id))
				errors.add(:recipient_id, "No such channel belongs to your team.")
			end
		when "User"
			if !(User.find(sender_id).team_members.ids.include?(recipient_id))
				errors.add(:recipient_id, "There is no such user in your team.")
			end
		else
			errors.add(:recipient_type, "There is no such recipient type.")
		end
	end

#Query Scope
	scope :in_channels, ->(channel_array) { where(recipient_type: "Channel", recipient_id: channel_array)}
	scope :between_team_members, ->(first_member, second_member) { where(recipient_type: "User", recipient_id: [first_member, second_member], sender_id: [first_member, second_member]) }

	scope :today, -> { where(created_at: Date.today.midnight..Time.now) }
	scope :yesterday, -> { where(created_at: Date.yesterday.midnight..Date.today.midnight)}
	scope :this_week, -> { where(created_at: Date.today.beginning_of_week.midnight..Time.now)}
	scope :last_week, -> { where(created_at: Date.today.prev_week.midnight..Date.today.beginning_of_week.midnight)}
	scope :during_year, ->(year) { where(created_at: Date.new(year.to_i).all_year) }
	scope :during_month, ->(month) { where(created_at: parse_month(month)) }

	scope :with_text, ->(text) { where("content LIKE ?", "%#{text}%") }

#Private methods
	private
	def self.parse_month(month)
		if Date.strptime(month, "%m") <= Date.today
			Date.strptime(month, "%m").all_month
		else
			Date.strptime(month, "%m").prev_year.all_month
		end
	end
		
end