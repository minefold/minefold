class Servers::GameplayController < ApplicationController

  prepend_before_filter :authenticate_user!

  expose(:server)

  respond_to :html

  def update
    schema = Brock::Schema.new(server.funpack.settings_schema)
    settings = schema.parse_params(params[:brock])
    server.update_attribute(:settings, settings)
    respond_with(server, location: edit_server_path(server))
  end

end
