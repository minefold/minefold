require 'test_helper'

class CoinsMailerTest < ActionMailer::TestCase

  test "receipt email" do
    user = User.make!
    coin_pack = CoinPack.make!

    # TODO Stripe should be stubbed out because its a Unit test
    card = Stripe::Token.create(card: {
        number: StripeCards[:default],
        exp_month: Time.now.month,
        exp_year: 1.year.from_now.year,
        cvc: 123,
        name: Faker::Name.name
      })

    charge = Stripe::Charge.create(
      amount: coin_pack.cents,
      currency: 'usd',
      card: card.id
    )

    # Send the email, then test that it got queued
    email = CoinsMailer.receipt(user.id, charge.id, coin_pack.id).deliver

    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [user.email], email.to
    assert_equal "Minefold Receipt #{charge.id}", email.subject

    # TODO Test more attributes of the receipt
  end

end
