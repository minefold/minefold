class AdminController < ApplicationController

  http_basic_authenticate_with name: 'admin', password: 'carlsmum'

  layout nil

  def index
    @users = User.order_by([:created_at, :desc]).all
  end

end
