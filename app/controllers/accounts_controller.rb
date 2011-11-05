class AccountsController < ApplicationController

  def show
  end

  def billing
  end

  def card
  end

  def dashboard
  end

  def change_plan
    current_user.plan = params[:plan_id]
    current_user.save

    redirect_to :back
  end


end
