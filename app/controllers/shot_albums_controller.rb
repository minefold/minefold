class ShotAlbumsController < ApplicationController
  prepend_before_filter :authenticate_user!

  def create
    @shot_album = ShotAlbum.new
    @shot_album.name = params[:name]
    @shot_album.creator = current_user
    @shot_album.save
    redirect_to '/shots/admin'
  end

  def destroy
    @shot_album = ShotAlbum.find(params[:id])
    if params[:cascade] == "true"
      @shot_album.shots.each &:delete
    end
    @shot_album.delete
    redirect_to '/shots/admin'
  end

  def update
    @shot_album = ShotAlbum.find(params[:id])
    @shot_album.update_attributes params.slice :name, :description
    redirect_to "/shots/admin/albums/#{@shot_album.id}"
  end

  # ---

  def admin
    @shot_album = ShotAlbum.find(params[:id])
    @shot_albums = ShotAlbum.all(
      conditions: { creator_id: current_user.id},
      sort: [[:created_at, :desc]]
    )
    render 'shots/admin_album'
  end

end