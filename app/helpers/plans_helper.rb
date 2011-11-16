module PlansHelper
  def current_plan
    Plan.find_by_stripe_id current_user.plan_id
  end

end