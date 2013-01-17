class ServersController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!, :except => [:show, :map, :list]
  prepend_before_filter :set_funpack_params!, :only => [:new]

# --

  expose(:server)

# --

  def index
    @servers = current_user.created_servers.group_by {|s| s.funpack.game }
  end

  def new
    authorize! :create, server
    @games = GAMES.published
  end

  def create
    authorize! :create, server

    server.creator = current_user
    server.users << current_user

    if server.save
      track 'Created server',
        name: server.name,
        url: server_url(server),
        shared: server.shared?,
        funpack: server.funpack.name,
        game: server.game.name
    else
      # Renders the new action
      @games = GAMES.published
    end

    respond_with(server)
  end

  def show
  end

  def map
    not_found unless server.game.mappable?
  end

  def edit
    authorize! :update, server
  end

  def update
    authorize! :update, server

    # TODO Actual error checking here!
    server.update_attributes(params[:server])

    if params[:restart].present?
      PartyCloud.stop_server(server.party_cloud_id)
    end

    respond_with(server)
  end

  def start
    authorize! :update, server

    session = server.sessions.create

    PartyCloud.start_server(
      server.party_cloud_id,
      server.funpack.party_cloud_id,
      server.settings
    )

    respond_with(server)
  end

  def stop
    authorize! :update, server
    PartyCloud.stop_server(server.party_cloud_id)
    respond_with(server)
  end


  def destroy
    authorize! :destroy, server

    if server.up?
      Resque.enqueue(StopServerJob, server.id)
    end

    server.destroy

    redirect_to(servers_path, notice: "Server \"#{server.name}\" was destroyed.")
  end

  def list
    cache_entry = Rails.cache.read('/servers/list')
    if cache_entry
      @entries = JSON.load(cache_entry)
    else
      @entries = []
      Server.select('id').find_each{|s| @entries << s.id }

      Rails.cache.write('/servers/list', JSON.dump(@entries), expires_in: 1.hour)
    end
  end

  private

  def set_funpack_params!
    if params[:game] and (game = GAMES.find(params[:game]))
      params[:server] ||= {}
      if params[:funpack] and (funpack = Funpack.find_by_slug(params[:funpack]))
        params[:server][:funpack_id] = funpack.id
      else
        params[:server][:funpack_id] = game.funpack_id
      end
    end
  end
end
