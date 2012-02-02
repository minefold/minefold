class ShotsController < ApplicationController
  respond_to :html

  def everyone
    @page = params[:page].to_i
    @pages = (Shot.count/shots_per_page.to_f).ceil

    @shots = Shot.all(
      conditions: { public: true },
      sort: [[:created_at, :desc]],
      limit: 18,
      skip: @page * shots_per_page
    )
    render :everyone
  end

  def for_user
    @user = User.find_by_slug!(params[:user_slug])

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

  def show
    id = params[:id].split('-').first
    @shot = Shot.find(id) or raise Mongoid::Errors::DocumentNotFound
    render :show
  end

  prepend_before_filter :authenticate_user!, :only => :admin
  def admin
    @shots = Shot.all(
      conditions: { creator_id: current_user.id},
      sort: [[:created_at, :desc]]
    )
    render :admin
  end

  def update
    @shot = Shot.find params[:id]
    @shot.title = params[:title]
    @shot.public = params[:public]
    @shot.save
    redirect_to '/shots/admin'
  end

  def destroy
    @shot = Shot.find params[:id]
    @shot.destroy
    redirect_to '/shots/admin'
  end

  # ---

  def shots_per_page
    18
  end

end