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
    @user = User.where(:slug => params[:user_slug]).first
    not_found if @user.nil?

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
    @shot = Shot.find(id)
    not_found if @shot.nil?

    render :show
  end

  # ---

  def shots_per_page
    18
  end

end