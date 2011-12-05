class AccountsController < ApplicationController

  respond_to :html, :json

  def dashboard
  end

  def update
    current_user.update_attributes(params[:user])

    if current_user.save
      flash[:success] = 'Your settings were changed'
    end

    respond_with current_user, :location => account_path
  end

  def billing
  end

end
