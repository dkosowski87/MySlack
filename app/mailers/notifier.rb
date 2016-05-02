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

	def send_activate_request(user)
		@user = user
		@team_founder = @user.team.team_founder
		mail to: @team_founder.email, subject: "Account activation request"
	end

	def send_activate_response(user)
		@user = user
		mail to: @user.email, subject: "Your account has been activated"
	end

end