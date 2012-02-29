class AccountsController < ApplicationController
  prepend_before_filter :authenticate_user!

  respond_to :html, :json

  skip_before_filter :require_username!, only: [:username, :update]

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

    # raise "#{request.referer.inspect} #{current_user.errors.inspect}"

    respond_with current_user, :location => account_path
  end

  def fetch_avatar
    authorize! :update, current_user

    current_user.fetch_avatar
  end

  def time
  end

end
