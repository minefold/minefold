class UserController < ApplicationController

  def show
  end

  layout 'signup', :only => :new

  def new
    @invite = Invite.unclaimed.first(:token => params[:token])
    raise MongoMapper::DocumentNotFound unless @invite

    @user = User.new :invite_id => @invite.id
  end

  def create
    @user = User.create! params[:user]
    redirect_to :root
  end

end
