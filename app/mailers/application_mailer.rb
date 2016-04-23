class ApplicationMailer < ActionMailer::Base
  default from: "from@myslack.com"
  layout 'mailer'
end
