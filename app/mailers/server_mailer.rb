class ServerMailer < ActionMailer::Base
  include Resque::Mailer
  include MixpanelMailerHelpers
  
  def comment(server_id, comment_id)
    @server = Server.find(server)
    @comment = @server.comments.find(comment_id)
    
    recipients = @server.members.reject {|m| m == @comment.author }
                                .map {|m| m.email }
                                .flatten
    
    mail bcc: recipients,
         subject: "#{@comment.author.username} commented on #{@world.name_with_creator}"
  end
  
end
