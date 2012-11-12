class BonusClaim < ActiveRecord::Base
  attr_accessible :user, :bonus_type, :credits

  belongs_to :user
end
