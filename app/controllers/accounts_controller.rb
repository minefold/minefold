class AccountsController < ApplicationController
  prepend_before_filter :authenticate_user!

  respond_to :html, :json

  def dashboard
  end

  def edit
  end

  def update
    authorize! :update, current_user

    current_user.update_attributes(params[:user])

    if current_user.save
      flash[:success] = 'Your settings were changed'
    end

    respond_with current_user, :location => account_path
  end

  def time
  end

end
