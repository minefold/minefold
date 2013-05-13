class AccountsController < ApplicationController
  respond_to :html

  prepend_before_filter :authenticate_user!

# --

  expose(:account)

# --

  def destroy
    authorize! :destroy, current_user

    account.destroy

    # TODO Check if the user is playing on a server that uses this account type and kick them if they are.

    flash[:notice] = 'Account unlinked'
    redirect_to edit_user_registration_path
  end

end
