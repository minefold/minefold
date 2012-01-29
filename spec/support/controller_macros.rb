module ControllerMacros

  # TODO Keep an eye on https://github.com/rspec/rspec-core/issues/126
  def signin_as(&blk)
    let!(:current_user, &blk)

    go_go_power_devise!

    # prepend_before(:each) do
    before(:each) do
      sign_in(current_user)
    end
  end

  # TODO Name better, drinking!
  def go_go_power_devise!
    before(:each) { @request.env['devise.mapping'] = Devise.mappings[:user] }
  end
end
