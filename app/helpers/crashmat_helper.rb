module CrashmatHelper

  def crashmat_config
    {
      key: ENV['CRASHMAT'],
      user: crashmat_user
    }
  end

  def crashmat_user
    signed_in? and {
      id:    current_user.id,
      email: current_user.email,
      name:  current_user.username
    }
  end

end
