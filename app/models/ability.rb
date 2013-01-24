class Ability
  include CanCan::Ability

  def initialize(user)
    # Public abilities
    can :read, [Server, Comment, User]

    return false unless user

    # Users can only edit themselves
    can [:update, :destroy], User, id: user.id

    can :manage, Account, user_id: user.id

    # Admin abilities
    if user.admin?
      can [:update, :destroy, :operate, :play], Server
    end

    # Servers
    can [:create], Server
    can [:update, :destroy], Server, creator_id: user.id

    # Comments
    can [:create], Post
  end
end
