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

shared_examples "authenticated action" do

    it "authenticates the user" do
      expect(warden).to be_authenticated(:user)
      # expect(warden.authenticated?(:user)).to be_true

      # expect(@request.env['action_controller.instance'])
      #   .to be_a(Devise::FailureApp)
    end

end
