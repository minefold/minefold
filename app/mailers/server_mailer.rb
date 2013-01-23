class ServerMailer < ActionMailer::Base
  include Resque::Mailer

  def comment(server_id, comment_id)
    @server = Server.find(server_id)
    @comment = @server.comments.find(comment_id)

    recipients = @server.users.reject {|m| m == @comment.author }
                              .map {|m| m.email }
                              .flatten

    mail bcc: recipients,
         subject: "#{@comment.author.username} commented on #{@server.name}"
  end

end
