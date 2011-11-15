class AccountsController < ApplicationController

  def dashboard
  end

  def show
  end

  def update
    current_user.update_attributes! params[:user]
    redirect_to account_path
  end

  def billing
  end

end
