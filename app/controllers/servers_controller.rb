class ServersController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!, :except => [:show, :map]

# --

  expose(:server)

# --

  def index
  end

  def new
    @games = Game.all
    # TODO replace with actual data in Javascript
    @funpack = Funpack.first
  end
  
  # TODO This method is a bit of a hack, but I can't think of any better way to do it without re-implementing the entire thing in Javascript and shipping it all down to the client.
  def new_funpack_settings
    @funpack = Funpack.find(params[:funpack_id])
    
    render layout: false
    # = f.fields_for :settings do |s|
    #       = render partial: @funpack.game.settings_partial, locals: {f: s}
  end

  def create
    server.creator = current_user
    server.users << current_user

    server.save
    respond_with(server)
  end

  def show
  end
  
  def map
    not_found unless server.funpack.game.minecraft?
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
