require 'spec_helper'

describe OrdersController do
  signin_as { Fabricate :user }

  describe '#create' do
    before { 
      
      Stripe::Charge.should_receive(:create).with( 
        card: 'token666',
        amount: 1500,
        currency: 'usd',
        description: "3 months of Minefold Pro"
      ) { true }
      
      Timecop.freeze
      post :create, stripe_token: 'token666', pack_id: 'beta-3m-1500'
    }
    
    after { Timecop.return }
    
    context 'response' do
      subject { response }
      it { should redirect_to user_root_path }
    end
    
    context 'user' do
      subject { current_user.reload }
      
      its(:plan_expires_at) { should == Time.now + 3.months }
    end
  end
end