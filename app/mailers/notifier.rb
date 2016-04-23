class Notifier < ApplicationMailer
	default from: 'notifications@myslack.com'

	def welcome(user)
		@user = user
		mail to: @user.email, subject: "Welcome to MySlack #{user.name}"
	end

	def password_reset(user)
		@user = user
		mail to: @user.email, subject: "Reset your password"
	end

end