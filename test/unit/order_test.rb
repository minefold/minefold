require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  test "#credit_pack" do
    credit_pack = CreditPack.make!
    assert_equal credit_pack, Order.new(credit_pack.id).credit_pack
    assert_equal nil, Order.new(nil).credit_pack
    assert_equal nil, Order.new(credit_pack.id+1).credit_pack
  end

  test "#valid?" do
    credit_pack = CreditPack.make!
    new_user = User.make!
    existing_user = User.make!(customer_id: 'cus_1')

    assert !Order.new.valid?, 'empty order is invalid'

    assert !Order.new(credit_pack.id).valid?, 'only credit pack is invalid'
    assert !Order.new(credit_pack.id + 1, existing_user).valid?, 'wrong credit_pack_id is invalid'

    assert !Order.new(credit_pack.id, new_user).valid?, 'new user without card_token is invalid'

    assert Order.new(credit_pack.id, existing_user).valid?, 'existing user without card is valid'
    assert Order.new(credit_pack.id, existing_user, 'tok_2').valid?, 'existing user with new card is valid'
    assert Order.new(credit_pack.id, new_user, 'tok_1').valid?, 'new user with card is valid'
  end

  test "#create_charge" do
    credit_pack = CreditPack.make!(id: 10, cents: 100)
    user = User.make!(customer_id: 'cus_1')
    
    mock(Stripe::Charge).create(
      amount: 100,
      currency: 'usd',
      customer: 'cus_1',
      description: '10'
    ) do
      charge = Object.new
      stub(charge).id { 'ch_0bV6FV0MNgTzlg' }
      charge
    end

    order = Order.new(credit_pack, user)
    order.create_charge
  end

  test "#create_or_update_customer creates a customer" do
    credit_pack = CreditPack.make!
    user = User.make!

    mock(user).create_customer('tok_1')

    order = Order.new(credit_pack, user, 'tok_1')
    order.create_or_update_customer
  end

  test "#create_or_update_customer updates a customers card" do
    credit_pack = CreditPack.make!
    user = User.make!(customer_id: 'cus_1')

    customer = mock(Object.new)
    customer.card = 'tok_2'
    customer.save

    stub(Stripe::Customer).retrieve('cus_1') { customer }

    order = Order.new(credit_pack, user, 'tok_2')
    order.create_or_update_customer
  end

  test "#fulfill fails if #create_or_update_customer fails" do
    credit_pack = CreditPack.make!
    user = User.make!
    order = Order.new(credit_pack.id, user, 'tok_1')

    stub(order).create_or_update_customer { false }
    dont_allow(order).create_charge
    dont_allow(order).credit_user

    assert !order.fulfill, 'order completes'
  end

  test "#fulfill fails if #create_charge raises an error" do
    credit_pack = CreditPack.make!
    user = User.make!
    order = Order.new(credit_pack.id, user, 'tok_1')

    stub(order).create_or_update_customer { true }
    stub(order).create_charge { raise Stripe::StripeError }
    dont_allow(order).credit_user

    assert !order.fulfill, 'order completes'
  end

  test "#fulfill fails if #credit_user fails" do
    credit_pack = CreditPack.make!
    user = User.make!
    order = Order.new(credit_pack.id, user, 'tok_1')

    stub(order).create_or_update_customer { true }
    stub(order).create_charge { true }
    stub(order).credit_user { false }

    assert !order.fulfill, 'order completes'
  end

end
