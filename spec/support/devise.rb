module DeviseControllerMacros

  def setup_devise_mapping(role)
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[role]
    end
  end

end

# --

RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend DeviseControllerMacros, :type => :controller
end

# --

RSpec::Matchers.define :authenticate_user do
  match do |actual|
    actual.redirect? && actual.redirect_url == 'http://test.host/user/sign_in'
  end
end
