class ShotsController < ApplicationController
  respond_to :html

  # ---

  def everyone
    @page = params[:page].to_i
    @page = 1 if @page.zero?

    @pages = (Shot.count/shots_per_page.to_f).ceil

    @shots = Shot.all(
      conditions: { public: true },
      sort: [[:created_at, :desc]],
      limit: 18,
      skip: (@page-1) * shots_per_page
    )
    render :everyone
  end

  def for_user
    @user = User.find_by_slug!(params[:user_slug])
    @shot_albums = @user.shot_albums

    @page = params[:page].to_i
    @pages = (Shot.count/shots_per_page.to_f).ceil

    @shots = Shot.all(
      conditions: { public: true, creator_id: @user.id},
      sort: [[:created_at, :desc]],
      limit: shots_per_page,
      skip: @page * shots_per_page
    )
    render :for_user
  end

  def for_album
    @user = User.find_by_slug!(params[:user_slug])
    @shot_album = ShotAlbum.find_by_slug!(params[:shot_album_slug])

    @page = params[:page].to_i
    @pages = (Shot.count/shots_per_page.to_f).ceil

    @shots = Shot.all(
      conditions: { public: true, creator_id: @user.id, :shot_album_id => @shot_album.id},
      sort: [[:created_at, :desc]],
      limit: shots_per_page,
      skip: @page * shots_per_page
    )

    render :for_album
  end

  def show
    id = params[:id].split('-').first
    @shot = Shot.find(id)
    render :show
  end

  # ---

  prepend_before_filter :authenticate_user!, :only => :admin
  def admin
    @private_no_album_shots = Shot.
      where(creator_id: User.first.id).
      where(shot_album_id: nil).
      any_in(public: [nil,false]).
      desc(:updated_at)

    @public_no_album_shots = Shot.
      where(creator_id: User.first.id).
      where(shot_album_id: nil).
      any_in(public: [true]).
      desc(:updated_at)

    @shot_albums = ShotAlbum.all(
      conditions: { creator_id: current_user.id},
      sort: [[:created_at, :desc]]
    )
    render :admin
  end

  # ---

  def update
    @shot = Shot.find params[:id]
    @shot.update_attributes params.slice :title, :public, :shot_album_id
    # developer sppeeeeeeeddd
    redirect_to(
      if request.referer[/albums\/(.+?)$/,1] && $1 != @shot[:shot_album_id].to_s
        '/shots/admin'
      else
        request.referer
      end)
  end

  def destroy
    @shot = Shot.find params[:id]
    @shot.delete
    redirect_to '/shots/admin'
  end

  # ---

  def shots_per_page
    18
  end

end
