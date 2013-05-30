class DashboardController < ApplicationController

  def index
    created_servers = current_user.created_servers.order(:updated_at)
    bookmarked_servers = current_user.watching.order(:updated_at)
    @servers = created_servers | bookmarked_servers
  end

end
