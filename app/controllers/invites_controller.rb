class InvitesController < ApplicationController
  respond_to :json

  def create
    current_user.invites.create! params[:invite]
    
    track 'sent invite', type: 'facebook'
    
    render json: {}
  end
end
