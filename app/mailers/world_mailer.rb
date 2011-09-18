class WorldMailer < ActionMailer::Base
  include Resque::Mailer
  default from: 'team@minefold.com'
  layout 'email'

  def play_request(world_id, owner_id, user_id)
    @world = World.find(world_id)
    @owner = User.find(owner_id)
    @user = User.find(user_id)

    mail   to: @owner.email,
      subject: "#{@user.username} would like to play in #{@world.name}"
  end

  class Preview < MailView
    def play_request
      ::WorldMailer.play_request(World.default.id,
                                 World.default.owner.id,
                                 User.dave.id)
    end
  end
end
