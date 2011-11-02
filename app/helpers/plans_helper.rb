module PlansHelper
  def plan_change_action user, new_plan
    old_plan = Plan.find(user.plan)

    case
    when old_plan.price < new_plan.price
      'Upgrade'
    when old_plan.price > new_plan.price
      'Downgrade'
    else
      'Your plan'
    end
  end

  def plan_price plan_id
    Plan.find(plan_id).price
  end
end