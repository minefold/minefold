class ServersController < ApplicationController
  respond_to :html, :js, :json

  prepend_before_filter :authenticate_user!, :except => [:show, :list]
  prepend_before_filter :set_funpack_params!, :only => [:new]

  before_filter :set_last_visited_cookie, :only => :show

# --

  expose(:server)
  expose(:funpacks) {
    if $flipper[:unpublished_funpacks].enabled?(current_user)
      Funpack.order(:name).all
    else
      Funpack.order(:name).published
    end
  }
  expose(:funpack) {
    if params[:funpack]
      Funpack.find(params[:funpack])
    end
  }

# --

  def index
    @created_servers = current_user.created_servers
  end

  def new
    server.funpack ||= funpack
    authorize! :create, server
  end

  def create
    authorize! :create, server

    # Set the creator
    server.creator = current_user
    server.users << current_user

    # The access access policy to whatever the funpack defaults to
    server.access_policy_id = server.funpack.default_access_policy_id

    # Server owners automatically watch the server
    server.watchers << server.creator

    Activities::CreatedServer.publish(server)

    if server.save
      # TODO Move this out to a Job so it can be repeated. Show a spinner where the address should be and something like "acquiring server".

      server.party_cloud_id ||= PartyCloud::Server.create(server.funpack, server.name).id
      server.save

      # Analytics.track(
      #   user_id: server.creator.distinct_id,
      #   event:   'Created server',
      #   properties: {
      #     name:    server.name,
      #     url:     server_url(server),
      #     funpack: server.funpack.name
      #   }
      # )

      flash[:abba_complete] = true

      track server.creator.distinct_id, 'Created server',
        name: server.name,
        url: server_url(server),
        funpack: server.funpack.name
    end

    respond_with(server)
  end

  def show
  end

  def logs
  end

  def edit
    authorize! :update, server
  end

  def update
    authorize! :update, server

    # TODO Actual error checking here!
    server.update_attributes(params[:server])

    respond_with(server, location: edit_server_path(server))
  end

  def start
    authorize! :update, server

    session = server.sessions.create

    server.start!

    PartyCloud.start_server(
      server.party_cloud_id,
      server.funpack.party_cloud_id,
      { name: server.name,
        access: server.access_policy.to_hash,
        settings: server.settings
      }.to_json
    )

    respond_to do |format|
      format.js { render(json: {
        state: server.state_name,
        address: server.address.to_s
      }) }
    end
  end

  def stop
    authorize! :update, server
    PartyCloud.stop_server(server.party_cloud_id)

    server.host = nil
    server.port = nil
    server.save!

    server.stop!

    respond_to do |format|
      format.js {
        render(json: {
          state: server.state_name,
          address: server.address.to_s
        })
      }
    end
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
    # if params[:game] and (game = GAMES.find(params[:game]))
    #   params[:server] ||= {}
    #   if params[:funpack] and (funpack = Funpack.find_by_slug(params[:funpack]))
    #     params[:server][:funpack_id] = funpack.id
    #   else
    #     params[:server][:funpack_id] = game.funpack_id
    #   end
    # end
  end

  def set_last_visited_cookie
    cookies[:last_viewed_server_id] = {
      value: server.id,
      expires: 1.year.from_now,
      httponly: true
    }
  end

end
