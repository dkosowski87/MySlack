# Preview all emails at http://localhost:3000/rails/mailers/notifier
class NotifierPreview < ActionMailer::Preview
	def welcome
		Notifier.welcome(User.first)
	end

	def password_reset
		Notifier.password_reset(User.first)
	end

	def send_activate_request
		Notifier.send_activate_request(User.last)
	end
end
