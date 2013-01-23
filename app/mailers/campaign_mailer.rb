class CampaignMailer < ActionMailer::Base
  include Resque::Mailer
end
