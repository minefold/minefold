module ControllerMacros

  # TODO Keep an eye on https://github.com/rspec/rspec-core/issues/126
  def signin_as(&blk)
    let!(:current_user, &blk)

    remap_devise!

    # prepend_before(:each) do
    before(:each) do
      sign_in(current_user)
    end
  end

  def remap_devise!
    before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }
  end
end
