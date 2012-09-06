class SessionMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers
end
