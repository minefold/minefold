class UserVerifiedJob < Job
  @queue = :high

  def initialize(username, verification_token)
    @user = User.where(verification_token: verification_token).first
    @player = MinecraftPlayer.find_by_username(username)
  end

  def tell_player message
    @player.tell "[MINEFOLD] #{message}" if @player.online?
  end

  def perform?
    not @player.verified?
  end

  def perform!
    if @user.nil?
      tell_player 'Sorry! That verification code is incorrect'

    else
      @player.user = @user
      @player.save

      minutes = @player.minutes_played

      Mixpanel.track 'player verified',
        distinct_id: @player.distinct_id,
        mp_name_tag: @player.friendly_id,
        minutes: minutes,
        hours: (minutes / 60.0).to_i,
        pro: @user.pro?

      begin
        @player.fetch_avatar
        @player.save
      rescue
        puts "fetch avatar failed"
      end

      @user.unset :verification_token

      @user.private_channel.trigger!('verified', @player.to_json)

      tell_player 'Welcome! Your account is now verified'
    end
  end

end
