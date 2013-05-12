class SubscriptionsController < ApplicationController
  prepend_before_filter :authenticate_user!

  def create
    @plan = Plan.find(params[:plan_id])

    @subscription = current_user.subscribe!(@plan, params[:stripeToken], params[:last4], params[:tradein])

    track(current_user.distinct_id, 'Paid',
      'plan'   => @plan.id,
      'amount' => @subscription.plan.cents
    )
    engage(current_user.distinct_id,
      '$add' => {
        'Spent' => @subscription.plan.cents
      }
    )

    # Mixpanel Revenue Analytics
    engage(current_user.distinct_id,
      '$append' => {
        '$transactions' => {
          '$time' => Time.now.utc.iso8601,
          '$amount' => (@subscription.plan.cents / 100.0)
        }
      }
    )

    redirect_to thank_you_subscriptions_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to plans_page_path
  end

  def update
    current_user.update_card!(params[:stripeToken], params[:last4])

    redirect_to edit_user_registration_path
  end

end
