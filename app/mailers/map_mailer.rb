class MapMailer < TransactionMailer

  def rendered(server_id)
    @server = Server.find(server_id)
    @user = @server.creator

    tag :map_rendered
    mail to: @user.email,
         subject: 'You Minefold map has finished rendering'
  end

end
