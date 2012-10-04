class Ability
  include CanCan::Ability

  def initialize(user)
    # Public abilities
    can :read, [Server, Comment, User]

    return false unless user

    # Users can only edit themselves
    can [:update, :destroy], User, id: user.id

    # Admin abilities
    # if user.admin?
    #   can [:update, :destroy, :operate, :play], Server
    # end

    # Server abilities
    can [:create], Server
    can [:update, :destroy], Server, creator_id: user.id

    can [:create], Comment
  end
end
