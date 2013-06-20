class LinkMojangAccountJob < Job
  @queue = :high

  attr_reader :token
  attr_reader :username

  attr_reader :user
  attr_reader :account

  def initialize(token, username)
    @token, @username = token, username
    @user = User.find_by_verification_token(token)
    @account = Accounts::Mojang.find_or_create_by_uid(username)
  end

  def perform
    # No user account found
    if user.nil?
      reply 'Bad code. Please copy and paste the verify address'

    # User already has a Minecraft account linked
    elsif user.accounts.mojang.any?
      reply "Already linked to #{user.accounts.mojang.first.uid}. Unlink at minefold.com"

    # Account is already linked to somebody else
    elsif account.user and account.user != user
      reply "#{account.uid} is already linked to another user."

    # All good, link the account! (Also shows if account.user == user)
    else
      account.user = user
      account.save!

      Bonuses::LinkedMojangAccount.give_to(user)

      reply "Linked account #{account.uid}. Visit minefold.com to play!"
    end
  end

  def reply(message)
    $party_cloud_redis.publish(
      "players:verification_request:#{@token}",
      message
    )
  end

end
