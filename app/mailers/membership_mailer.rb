class MembershipMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers
end
