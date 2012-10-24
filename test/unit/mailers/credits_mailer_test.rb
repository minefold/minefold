require 'test_helper'

class CreditsMailerTest < ActionMailer::TestCase

  test "receipt email" do
    user = User.make!
    credit_pack = CreditPack.make!
    
    card = Stripe::Token.create(card: {
        number: StripeCards[:default],
        exp_month: Time.now.month,
        exp_year: 1.year.from_now.year,
        cvc: 123,
        name: Faker::Name.name
      })
    
    charge = Stripe::Charge.create(
      amount: credit_pack.cents,
      currency: 'usd',
      card: card.id
    )
 
    # Send the email, then test that it got queued
    email = CreditsMailer.receipt(user.id, charge.id, credit_pack.id).deliver
    
    assert !ActionMailer::Base.deliveries.empty?
 
    assert_equal [user.email], email.to
    assert_equal "Minefold Receipt #{charge.id}", email.subject
    
    # TODO Test more attributes of the receipt
  end
  
end
