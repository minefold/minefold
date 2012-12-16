# TODO Rename this to LinkMojangAccountJob
class LinkMinecraftPlayerJob < Job
  @queue = :high

  def initialize(verification_token, username)
    @verification_token, @username = verification_token, username
    @user = User.find_by_verification_token(verification_token)
    @account = Accounts::Mojang.find_by_uid(username)
  end

  def perform!
    if @user.nil?
      reply 'Bad code. Please copy and paste the verify address'

    elsif @account and @account.user
      if @user.accounts.minecraft.include?(@account)
        reply "#{@username} already linked to your account."
      elsif @user.accounts.minecraft.any?
        reply "Account is linked to #{@user.accounts.minecraft.first.uid}. Unlink at minefold.com"
      else
        reply "#{@username} is linked to another account. Unlink account to change"
      end

    else
      account = Accounts::Mojang.find_or_initialize_by_uid(@username)
      account.user = @user
      account.save!

      Bonuses::LinkedMojangAccount.claim!(@user)

      reply "Linked. Visit minefold.com to play!"
    end
  end

  def reply(message)
    $redis.publish(
      "players:verification_request:#{@verification_token}",
      message
    )
  end

end
