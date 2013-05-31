class DashboardController < ApplicationController

  def index
    created_servers = current_user.created_servers.order('updated_at desc')
    bookmarked_servers = current_user.watching.order('updated_at desc')
    @servers = created_servers | bookmarked_servers
  end

end
