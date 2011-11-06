class PagesController < ApplicationController

  def home
    redirect_to(user_root_path) if signed_in?
  end

  def time
  end

  def features
  end

  def about
  end

  def jobs
  end

  def contact
  end

  def help
  end

  def privacy
  end

  def terms
  end

end
