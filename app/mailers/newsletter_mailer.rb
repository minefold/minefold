class NewsletterMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers
end
