module ControllerMacros

  def signin_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in current_user
    end
  end

end
