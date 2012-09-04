class ServersController < ApplicationController

  prepend_before_filter :authenticate_user!, :only => [:index]

  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
