class DashboardController < ApplicationController

  def index
    created_servers = current_user.created_servers
    bookmarked_servers = current_user.watching
    @servers = bookmarked_servers | created_servers
  end

end
