class Api::SessionsController < Api::ApiController
  def create
    render status: 200, layout: false, nothing: true
  end
end
