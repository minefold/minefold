class PagesController < ApplicationController

  prepend_before_filter :authenticate_user!, :only => [:welcome]

  def about
  end

  def freetime
  end

  def support
  end

  def home
  end

  def jobs
  end

  def pricing
    @packs = CreditPack.active.all
  end

  def privacy
  end

  def terms
  end

  def welcome
  end

end
