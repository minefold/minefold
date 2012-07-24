class PagesController < ApplicationController

  prepend_before_filter :authenticate_user!, :only => [:freetime]

  def about
  end

  def freetime
  end

  def help
  end

  def home
  end

  def jobs
  end

  def pricing
  end

  def privacy
  end

  def terms
  end

end
