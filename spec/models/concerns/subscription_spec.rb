require 'spec_helper'

describe Subscription do
  subject { User.make }

  let(:plan) { Plan.make(id: 1) }

  context 'with no stripe customer' do
    it 'creates a customer and subscription' do
      Timecop.freeze(Time.now) do
        customer = stub(:customer, id: 'cus_1')

        Stripe::Customer.should_receive(:create).with(
          email: subject.email,
          card:  'tok_1234'
        ) { customer }

        end_timestamp = (Time.now + 1.month).to_i
        customer.should_receive(:update_subscription).with(
          plan: plan.stripe_id,
          card: 'tok_1234'
        ) { stub(:subscription, current_period_end: end_timestamp ) }

        subject.subscribe! plan, 'tok_1234', '4242'

        subject.subscription.created_at.should == Time.now
        subject.subscription.expires_at.should == Time.at(end_timestamp)
      end
    end

    context 'with a stripe customer' do
      before { subject.customer_id = 'cus_1' }

      it 'updates the customer and subscription' do
        Timecop.freeze(Time.now) do
          customer = stub(:customer, id: 'cus_1')
          Stripe::Customer.should_receive(:retrieve).with('cus_1') {
            customer
          }

          customer.should_receive(:update_subscription).with(
            plan: plan.stripe_id,
            card: 'tok_1234'
          ) { stub(:subscription, current_period_end: (Time.now + 1.month).to_i ) }

          subject.subscribe! plan, 'tok_1234', '4242'

          subject.subscription.created_at.should == Time.now
        end
      end
    end
  end
end