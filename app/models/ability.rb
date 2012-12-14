class Ability
  include CanCan::Ability

  def initialize(user)
    # Public abilities
    can :read, [Server, Comment, User]

    return false unless user

    # Users can only edit themselves
    can [:update, :destroy], User, id: user.id

    # Admin abilities
    if user.admin?
      can [:update, :destroy, :operate, :play], Server
    end

    # Servers
    can [:create], Server
    can [:update, :destroy], Server, creator_id: user.id

    # Comments
    can [:create], Post

    # Orders
    can [:create], Order
    can [:read], Order, user_id: user.id
  end
end
