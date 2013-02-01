require 'transaction_mailer'

class MapMailer < TransactionMailer

  def rendered(server_id)
    @server = Server.find(server_id)
    @user = @server.creator

    tag 'map#rendered'
    mail to: @user.email,
         subject: 'Minefold map rendered'
  end

end
