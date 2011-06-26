class UserController < ApplicationController

  def show
  end

  def new
    @user = User.new
  end

  def create
    invite = params[:user].delete(:invite)
    @user = User.first(:invite => invite)
    raise MongoMapper::DocumentNotFound unless @user

    @user.set params[:user]

    if @user.valid?
      @user.save
      redirect_to :root
    else
      flash[:errors] = @user.errors
      render :new
    end
  end

end
