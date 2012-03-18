# Triggered from in the game:
#
#   /email dave@minefold.com
#
class ClaimAccountJob < Job
  @queue = :low

  def initialize(world_id, username, email)
    @world_id = world_id
    @player = MinecraftPlayer.find_by_username(username)
    @email = email
  end

  def perform?
    @player.user.nil?
  end

  def perform!
    UserMailer.claim_account_info(@player.id, @email).deliver
  end
end
