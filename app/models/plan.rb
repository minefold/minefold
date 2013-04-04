class Plan < ActiveRecord::Base
  attr_accessible :bolts, :cents, :name, :stripe_id
  
  default_scope order('cents')
end
