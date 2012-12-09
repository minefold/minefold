class VotesController < ApplicationController

  def create

    server = Server.find(params[:server_id])

    vote = Vote.new
    vote.server = server

    vote.ip = request.remote_ip

    if signed_in?
      vote.user = current_user
    end

    vote.save!

    render text: 'ok'
  end

end
