require 'spec_helper'

describe AccountsController do
  render_views

  let(:user) do
    build(:user)
  end
  
  before do
    user.save!
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end
  
  describe '#update' do
    context 'stripe token supplied' do
      it "should create stripe customer" do
        expect_stripe_create user, 'tok_5xMxzGz8RNGA2L' 
        put :update, user: { stripe_token: 'tok_5xMxzGz8RNGA2L' }
        
        user.reload.stripe_id.should == 'cus_1'
      end
    end
  end
end