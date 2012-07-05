class Ability
  include CanCan::Ability

  def initialize(user)
    # Public abilities
    can :read, [World, User]

    return false unless user

    # # Admin abilities
    if user.admin?
      can [:update, :destroy, :operate, :play], World
    end

    # User abilities
    can [:create], World

    can [:update, :destroy], World, creator: user

    can :operate, World do |world|
      world.player_opped? user.minecraft_player
    end

    can :play, World do |world|
      not world.player_blacklisted?(user.minecraft_player) and
      (
        world.player_opped?(user.minecraft_player) or
        world.player_whitelisted?(user.minecraft_player)
      )
    end

    # 1. Can't clone own wold
    # 2. Can't clone a world that's already been cloned
    can :clone, World do |world|
      world.creator != user and not user.cloned?(world)
    end

    can [:update, :destroy], User, id: user.id
  end
end
