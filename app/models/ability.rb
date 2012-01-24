class Ability
  include CanCan::Ability

  def initialize(user)
    # Public abilities
    can :read, [World, User]

    return unless user

    # Admin abilities
    if user.admin?
      can [:update, :destroy, :operate, :play], World
    end

    # User abilities
    can [:create, :clone], World
    can [:update, :destroy], World, creator: user

    can :operate, World do |world|
      world.op? user
    end

    # 1. Can't clone own wold
    # 2. Can't clone a world that's already been cloned
    can :clone, World do |world|
      world.creator != user and not user.cloned?(world)
    end

    can :play, World do |world|
      world.member? user
    end

    can [:update, :destroy], User, id: user.id
  end
end
