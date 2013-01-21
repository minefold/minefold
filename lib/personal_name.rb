require 'active_support/core_ext/object/blank'

class PersonalName

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def full
    if user.first_name.present? and user.last_name.present?
      [user.first_name, user.last_name].join(' ')
    elsif user.name.present?
      user.name
    else
      user.username
    end
  end

  def first
    if user.first_name.present?
      user.first_name
    else
      user.username
    end
  end

end
