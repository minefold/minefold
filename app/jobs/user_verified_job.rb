class UserVerifiedJob < Job
  @queue = :high

  def initialize(username, verification_token)
    @user = User.where(verification_token: verification_token).first
    @player = MinecraftPlayer.find_by_username(username)
  end

  def perform?
    not @player.verified?
  end

  def perform!
    if @user.nil?
      @player.tell 'Sorry! That verification code is incorrect'
    else
      @player.verify!(@user)
      
      minutes = @player.minutes_played
      
      Mixpanel.track 'player verified',
        distinct_id: @player.distinct_id,
        mp_name_tag: @player.friendly_id,
        minutes: minutes,
        hours: (minutes / 60.0).to_i,
        pro: @user.pro?

      Mixpanel.track 'user verified',
        distinct_id: @user.distinct_id,
        mp_name_tag: @user.email,
        minutes: minutes,
        hours: (minutes / 60.0).to_i,
        pro: @user.pro?
    end
  end

end
