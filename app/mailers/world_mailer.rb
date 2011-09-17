class WorldMailer < ActionMailer::Base
  include Resque::Mailer
  default from: 'team@minefold.com'
  layout 'email'

  def play_request(world, user)
    @world = world
    @user = user

    mail   to: @world.creator.email,
      subject: "#{@user.username} would like to play in #{@world.name}"
  end

  class Preview < MailView
    def play_request
      ::WorldMailer.play_request(World.default, User.dave)
    end
  end
end
