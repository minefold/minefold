class AccountsController < ApplicationController

  def dashboard
  end

  def show
  end

  def update
    current_user.update_attributes! params[:user]
    current_user.save!
    
    redirect_to case
      when params[:return_url]
        params[:return_url]

      when params[:plan]
        account_plan_path(params[:plan])
        
      when params[:hours]
        account_time_path(params[:hours])
      else
        account_path
      end
  end

  def billing
  end

end
