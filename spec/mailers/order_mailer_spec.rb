require 'spec_helper'

describe OrderMailer do

  describe "#receipt" do

    let(:user) { User.make! }
    let(:coin_pack) { CoinPack.make! }

    let(:card) do
      {name: 'Chris Lloyd', type: 'Visa', last4: 1234}
    end

    let(:charge) do
      stub id: 'ch_1',
           card: card,
           amount: (100 + rand(100)),
           currency: 'usd',
           created: Time.now
    end

    subject {
      described_class.receipt(user.id, charge.id, coin_pack.id)
    }

    before do
      Stripe::Charge.stub(retrieve: charge)
    end

    it_behaves_like "transactional emails"

  end


end
