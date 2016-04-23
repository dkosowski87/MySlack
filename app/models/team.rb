class Team < ActiveRecord::Base

#Associations
	has_many :users, dependent: :destroy
	has_many :channels, dependent: :destroy

#Validations
	has_secure_password
	validates :name, presence: {message: "Please state the name of your team."},
									 length: {in: 3..15, message: "The name of your team should be between 3-15 characters"},
									 format: {with: /\A[a-zA-Z\d\s]+\z/, message: "Please use only letters and numbers. There can be whitespaces between words."}

#Callbacks
	after_create :create_general_channel!

	private
	def create_general_channel!
		channels.create(name: 'General')
	end

end
