class Ability
  include CanCan::Ability

  def initialize(user)
    can(:manage, :all) if user.admin?

    can [:read, :create], World
    can [:update, :destroy], World, creator: user

    can :operate, World do |world|
      world.op? user
    end
    can :play, World do |world|
      world.member? user
    end

    can :read, User
    can [:update, :destroy], User, id: user.id
  end
end
