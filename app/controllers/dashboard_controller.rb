class DashboardController < ApplicationController

  def index
    @created_servers = current_user.created_servers
  end

end
