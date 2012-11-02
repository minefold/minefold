class AccountsController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!

  def use_facebook_photo
  end

  def unlink_facebook
    current_user.facebook_uid = nil
    current_user.save

    flash[:notice] = 'Facebook account unlinked'
    redirect_to edit_user_registration_path
  end

  def use_minecraft_photo
  end

  def link_minecraft
    render layout: false
  end

  def unlink_minecraft
    @players = current_user.players.minecraft.each do |player|
      player.user = nil
      player.save
    end

    flash[:notice] = 'Minecraft account unlinked'
    redirect_to edit_user_registration_path
  end

end
