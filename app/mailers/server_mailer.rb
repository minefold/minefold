class ServerMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers
end
