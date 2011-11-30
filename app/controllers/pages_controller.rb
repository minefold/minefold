class PagesController < ApplicationController

  AVATARS = %W(brenda0006 chaolover91 ciner darknagzul dwi gtar hardhatmack lexi517 link47741 mattacrazy108 neo1616 ribs246 that1guy2112)

  def home
    redirect_to(user_root_path) if signed_in?

    @avatars = AVATARS.shuffle[0...10]
  end

end
