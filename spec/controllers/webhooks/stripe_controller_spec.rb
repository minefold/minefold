require 'spec_helper'

describe Webhooks::StripeController do
  before { Librato.should_receive(:increment).with('webhook.stripe.total') }

  describe "ping" do
    it "increments in librato" do
      Librato.should_receive(:increment).with('stripe.ping.total')
      Stripe::Event.should_receive(:retrieve).with('evt_1') do
        { type: 'ping' }
      end

      raw_post :create, {}, { id: 'evt_1' }.to_json
    end
  end

  describe "charge.succeeded" do
    let(:user) { User.make(customer_id: 'cus_1234') }

    it "sends email" do
      SubscriptionMailer.should_receive(:receipt).with(user.id, 'ch_1') {
        stub(:mail)
      }
      User.should_receive(:find_by_customer_id).with(user.customer_id) { user }
      Stripe::Event.should_receive(:retrieve).with('evt_1') do
        {
          type: 'charge.succeeded',
          data: {
            object: {
              id: 'ch_1',
              object: 'charge',
              customer: user.customer_id
            },
          }
        }
      end

      raw_post :create, {}, {id: 'evt_1'}.to_json
    end
  end
  
  describe "unhandled.type" do
    let(:user) { User.make(customer_id: 'cus_1234') }

    it "ignores" do
      Stripe::Event.should_receive(:retrieve).with('evt_1') do
        { type: 'unhandled.type' }
      end

      raw_post :create, {}, {id: 'evt_1'}.to_json
    end
  end

end
