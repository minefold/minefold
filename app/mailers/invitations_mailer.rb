require 'transaction_mailer'

class InvitationsMailer < TransactionMailer
  include TimeHelper

  def invitation(invitation_id)
    @invitation = Invitation.find(invitation_id)
    @sender_name = PersonalName.new(@invitation.sender).full

    tag 'invitations#invitation'
    mail to: @invitation.email,
         subject: "#{@sender_name} invited you to check out Minefold",
         from: "#{@sender_name} via #{ActionMailer::Base.default[:from]}"
  end

end
