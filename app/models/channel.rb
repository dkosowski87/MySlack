class Channel < ActiveRecord::Base
#Associations
	belongs_to :team

	belongs_to :admin, class_name: "User", foreign_key: "admin_id"
	has_and_belongs_to_many :users, after_add: :send_join_info, after_remove: :send_leave_info

	has_many :received_msgs, -> { readonly }, class_name: "Msg", as: :recipient

#Validations
	validates :name, presence: {message: "Enter the channel name."},
									 length: {in: 3..15, message: "The name of your channel should be between 3-15 characters"},
									 format: {with: /\A[a-zA-Z\d\s]+\z/, message: "Please use only letters and numbers. There can be whitespaces between words."}

#Callbacks
	after_create :join_admin_as_user
	before_destroy :send_channel_closing_msg

	private

	def join_admin_as_user
		users << admin if admin.present?
	end

	def send_channel_closing_msg
		users.find_each do |user|
			admin.sent_msgs.create(content: "The #{name} channel has been deleted.", recipient_id: user.id, recipient_type: "User")
		end
	end

	def send_join_info(user)
		user.sent_msgs.create(content: "#{user.name} joined #{name} channel.", recipient_id: id, recipient_type: "Channel")
	end

	def send_leave_info(user)
		user.sent_msgs.create(content: "#{user.name} left #{name} channel.", recipient_id: id, recipient_type: "Channel")
	end

#State
	state_machine :state, :initial => :quiet do
		event :activate do
			transition :quiet => :active
		end
		event :increase_volume do
			transition :active => :loud
		end
		event :decrease_volume do
			transition :loud => :active
		end 
		event :mute do
			transition :active => :quiet
		end
	end

end