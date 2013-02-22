class Servers::GameplayController < ApplicationController

  prepend_before_filter :authenticate_user!

  expose(:server)

  respond_to :html

  def update
    schema = Brock::Schema.new(server.funpack.settings_schema)
    settings = schema.parse_params(params[:brock])
    server.update_attribute(:settings, settings)
    
    if params[:restart].present?
      PartyCloud.stop_server(server.party_cloud_id)
    end
    
    respond_with(server, location: edit_server_path(server))
  end

end
