module PlansHelper
  def plan_change_action user, new_plan
    old_plan = Plan.find(user.plan)
    
    case 
    when old_plan.cost < new_plan.cost
      'Upgrade'
    when old_plan.cost > new_plan.cost
      'Downgrade'
    else
      'Your plan'
    end
  end
  
  def plan_cost plan_id
    Plan.find(plan_id).cost
  end
end