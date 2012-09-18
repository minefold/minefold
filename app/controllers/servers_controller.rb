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
