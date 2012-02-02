class ShotsController < ApplicationController
  respond_to :html

  def everyone
    @shots = Shot.all conditions: { public: true }, sort: [[:created_at, :desc]], limit: 18
    render :everyone
  end

end