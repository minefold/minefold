class TimePacksController < ApplicationController
  expose(:pack) { TimePack.find(params[:id].to_i) }

  before_filter do
    if not current_user.customer?
      redirect_to customer_new_path(hours: pack.hours)
    end
  end
end
