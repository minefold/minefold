class Servers::MapsController < ApplicationController
  respond_to :html, :json

  expose(:server)

  def show
  end

  def embed
    render(layout: nil)
  end

end
