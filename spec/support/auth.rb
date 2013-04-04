module DeviseAuthMacros

  def current_user(&block)
    let(:current_user, &block)

    before(:each) do
      request.env['warden'].stub :authenticate! => current_user
      controller.stub :current_user => current_user
    end
  end

end

RSpec.configure do |config|
  # config.include Devise::TestHelpers, :type => :controller
  config.extend DeviseAuthMacros, :type => :controller
end
