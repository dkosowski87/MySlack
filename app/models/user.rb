class User < ActiveRecord::Base
	has_secure_password

#Associations
	belongs_to :team, counter_cache: :number_of_members

	has_many :adm_channels, class_name: "Channel", foreign_key: "admin_id"
	has_and_belongs_to_many :channels

	has_many :sent_msgs, class_name: "Msg", foreign_key: "sender_id", dependent: :destroy
	has_many :received_msgs, -> { readonly }, class_name: "Msg", as: :recipient
	
	has_many :sent_invitations, -> { where(recipient_type: "User") }, class_name: "Invitation", foreign_key: "sender_id"
	has_many :received_invitations, class_name: "Invitation", as: :recipient
	
#Validations
	validates :name, presence: {message: "Please state your name."},
									 format: {with: /\A[A-Z][a-z]+\z/, message: "Your name should start with an uppercase letter.", if: "name.present?"}
	validates :team_id, presence: true
	validates :email, presence: {message: "Please enter your email."},
										format: {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/, message: "The email has an improper format.", if: "email.present?"},
										uniqueness: {case_sensitive: false, message: "This email has already been taken."}
#Callbacks											
	after_create :send_welcome_msg, :join_general_channel

	private

	def send_welcome_msg
		team_members.find_each do |team_member|
			welcome_msg = sent_msgs.new( content: "Hi, my name is #{name} and I just joined your team. Go #{team.name}!", 
												  				 recipient_id: team_member.id,
												  	 			 recipient_type: "User" )
			welcome_msg.save
		end
	end

	def join_general_channel
		self.team.channels.first.users << self
	end

#Query Scope
	
	public
	def team_members
		team.users.where("id != ?", self.id)
	end

#State

	state_machine :state, :initial => :active do
		event :deactivate! do
			transition :active => :deactivated
		end
		event :activate! do
			transition :deactivated => :active
		end
	end

#Other instance methods

	def generate_password_reset_token!
		update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(48))
	end

end

