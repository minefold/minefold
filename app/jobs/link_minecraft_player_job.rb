class LinkMinecraftPlayerJob < Job
  @queue = :high

  def initialize(verification_token, username)
    @verification_token, @username = verification_token, username
    @user = User.find_by_verification_token(verification_token)
    @player = Player.minecraft.find_by_uid(username)
  end

  def perform!
    if @user.nil?
      reply 'Bad code. Please copy and paste the verify address'

    elsif @player and @player.user
      if @user.players.minecraft.include?(@player)
        reply "#{@username} already linked to your account."
      elsif @user.players.minecraft.any?
        reply "Account is linked to #{@user.players.minecraft.first.uid}. Unlink at minefold.com"
      else
        reply "#{@username} is linked to another account. Unlink account to change"
      end

    else
      player = Player.find_by_uid(@username)
      if player.nil?
        player = Player.create(
          uid: @username,
          game: Game.find_by_name('Minecraft')
        )
      end

      player.user = @user
      player.save!

      Bonuses::LinkedMinecraft.claim!(@user)
      
      reply "Linked. Visit minefold.com to play!"
    end
  end

  def reply message
    logger.info message
    $redis.publish "players:verification_request:#{@verification_token}", message
  end

end
