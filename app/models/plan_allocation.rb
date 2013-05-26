class PlanAllocation < ActiveRecord::Base
  belongs_to :plan
  belongs_to :funpack

  attr_accessible :plan, :ram, :players
end
