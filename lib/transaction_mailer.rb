require 'action_mailer'
require 'resque_mailer'

class TransactionMailer < ActionMailer::Base
  include Resque::Mailer
  layout 'mail/transaction'

  self.default from: 'support@minefold.com',
               reply_to: 'support@minefold.com'

  def tag(name)
    headers 'X-Mailgun-Tag' => name.to_s
  end

end
