class WorldsController < ApplicationController
  prepend_before_filter :authenticate_user!
  
  def create
    
  end
end
  