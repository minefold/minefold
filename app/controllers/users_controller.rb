class UsersController < ApplicationController

  def dashboard
    @worlds = World.available_to_play.recently_active.limit(3 * 4)
  end

end
