class Api::SessionController < Api::ApiController
  layout nil
  
  def show
    if current_user.current_world && 
       current_user.current_world.player_ids.include?(current_user.id)
      render json: { current_world: current_user.current_world.name }
    else
      render status: :not_found, nothing: true
    end
  end
end
