require 'transaction_mailer'

class InvitationsMailer < TransactionMailer
  def invitation(user_id, email)
    @user = User.find(user_id)

    @friendly_name = PersonalName.new(@user).full


    tag 'invitations#invitation'
    mail to: email,
         subject: "#{@friendly_name} invited you to check out Minefold",
         from: "#{@friendly_name} via #{ActionMailer::Base.default[:from]}"
  end
end
