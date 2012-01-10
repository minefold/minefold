module ControllerMacros

  def signin_as(&blk)
    let(:current_user, &blk)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in current_user
    end
  end

end
