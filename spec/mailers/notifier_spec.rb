require "rails_helper"

RSpec.describe Notifier, type: :mailer do
	let!(:user) { create(:user) }

  it "correctly creates the welcome email with the proper content" do
  	mailer = Notifier.welcome(user)
  	expect(mailer.to).to eq([user.email])
  	expect(mailer.subject).to eq("Welcome to MySlack #{user.name}") 
  end

  it "properly assigns the user instance variable" do
  	mailer = Notifier.welcome(user)
  	expect(mailer.body).to match(user.name)
  end
end
