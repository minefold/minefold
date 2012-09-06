class MembershipRequestMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers
end
