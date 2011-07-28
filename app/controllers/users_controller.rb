class UsersController < ApplicationController



  # TODO:
  #   prepend_before_filter :require_no_authentication, only: [:new, :create]

  # def new
  #   @invite = Invite.find_by_code(params[:code])
  #   not_found unless @invite
  #
  #   @user = User.new
  # end
  #
  # def create
  #   # TODO: Protect methods
  #   @user = User.new(params)
  #
  #   if @user.valid? and @user.save
  #     sign_in :user, @user
  #     redirect_to user_root_path
  #   else
  #     clean_up_passwords(resource)
  #     respond_with_navigational(resource) { render_with_scope :new }
  #   end
  #
  # end

  def dashboard
    @worlds = World.available_to_play.recently_active.limit(3 * 4)
  end

end
