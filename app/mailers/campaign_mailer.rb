class CampaignMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers
end
