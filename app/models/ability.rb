class Ability
  include CanCan::Ability

  def initialize(user)
    # Public abilities
    can :read, [Server, User]

    return false unless user

    # Users can only edit themselves
    can [:edit, :update, :destroy], User, id: user.id




    # Admin abilities
    if user.admin?
      can [:update, :destroy, :operate, :play], Server
    end

    # User abilities
    can [:create], Server

    can [:update, :destroy], Server, creator: user

    # can :operate, Server do |server|
    #   server.user_opped?(user)
    # end

    # can :play, Server do |world|
    #   not world.player_blacklisted?(user.minecraft_player) and
    #   (
    #     world.player_opped?(user.minecraft_player) or
    #     world.player_whitelisted?(user.minecraft_player)
    #   )
    # end
  end
end
