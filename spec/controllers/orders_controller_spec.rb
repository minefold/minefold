require 'spec_helper'

describe OrdersController do
  signin_as { Fabricate :user }

  describe '#create' do
    before {
      Stripe::Charge.should_receive(:create).with(
        card: 'token666',
        amount: 1500,
        currency: 'usd',
        description: "User##{current_user.id} beta-3m-1500"
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
      its(:plan_expires_at) { should == 3.months.from_now }
    end
  end
end