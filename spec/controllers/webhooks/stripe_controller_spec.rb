require 'spec_helper'

describe Webhooks::StripeController do
  before { Librato.should_receive(:increment).with('webhook.stripe.total') }

  describe "ping" do
    it "increments in librato" do
      Librato.should_receive(:increment).with('stripe.ping.total')

      raw_post :create, {}, { type: 'ping' }.to_json
    end
  end

  describe "charge.succeeded" do
    let(:user) { User.make(customer_id: 'cus_1234') }

    it "sends email" do
      SubscriptionMailer.should_receive(:receipt).with(user.id, 'ch_1') {
        stub(:mail)
      }
      User.should_receive(:find_by_customer_id).with(user.customer_id) { user }

      payload = {
        type: 'charge.succeeded',
        data: {
          object: {
            id: 'ch_1',
            object: 'charge',
            customer: user.customer_id
          },
        }
      }
      raw_post :create, {}, payload.to_json
    end
  end

end
