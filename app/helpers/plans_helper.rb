module PlansHelper

  def plan_change_action(current_plan, new_plan)
    prices = {
      'small' => 495,
      'medium' => 995,
      'large' => 1995
    }

    current_price = prices[current_plan] || 0
    new_price     = prices[new_plan]

    case
    when current_price < new_price
      :upgrade
    when current_price > new_price
      :downgrade
    else
      nil
    end
  end

  def plan_price plan_id
    Plan.find(plan_id).price
  end

end