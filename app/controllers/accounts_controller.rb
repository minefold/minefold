class AccountsController < ApplicationController

  def dashboard
  end


  def show
  end

  def update
    current_user.update_attributes params[:user]
    current_user.save
  end

  def time
  end

end
