class DashboardController < ApplicationController
  prepend_before_filter :authenticate_user!

  def index
  end
end
