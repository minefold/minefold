class Ability
  include CanCan::Ability

  def initialize(user)
    # Public abilities
    can :read, [World, User]

    return unless user

    # Admin abilities
    if user.admin?
      can :manage, :all
    end

    # User abilities
    can [:create], World
    can [:update, :destroy], World, creator: user

    can :operate, World do |world|
      world.op? user
    end

    can :clone, World do |world|
      world.creator != user and !user.cloned?(world)
    end

    can :play, World do |world|
      world.member? user
    end

    can [:update, :destroy], User, id: user.id
  end
end
