require 'test_helper'

class OrderTest < ActiveSupport::TestCase

  test "#coin_pack" do
    coin_pack = CoinPack.make!
    assert_equal coin_pack, Order.new(nil, coin_pack.id).coin_pack
    assert_equal nil, Order.new(nil, nil).coin_pack
    assert_equal nil, Order.new(nil, coin_pack.id+1).coin_pack
  end

  test "#valid?" do
    coin_pack = CoinPack.make!
    new_user = User.make!
    existing_user = User.make!(customer_id: 'cus_1')

    assert !Order.new(nil, nil).valid?, 'empty order is invalid'

    assert !Order.new(existing_user, coin_pack.id + 1).valid?, 'wrong coin_pack_id is invalid'

    assert !Order.new(new_user, coin_pack.id).valid?, 'new user without card_token is invalid'

    assert Order.new(existing_user, coin_pack.id).valid?, 'existing user without card is valid'
    assert Order.new(existing_user, coin_pack.id, 'tok_2').valid?, 'existing user with new card is valid'
    assert Order.new(new_user, coin_pack.id, 'tok_1').valid?, 'new user with card is valid'
  end

  test "#create_charge" do
    coin_pack = CoinPack.make!(id: 10, cents: 100)
    user = User.make!(customer_id: 'cus_1')

    mock(Stripe::Charge).create(
      amount: 100,
      currency: 'usd',
      customer: 'cus_1',
      description: coin_pack.description
    ) do
      charge = Object.new
      stub(charge).id { 'ch_0bV6FV0MNgTzlg' }
      charge
    end

    order = Order.new(user, coin_pack)
    order.create_charge

    assert_equal 'ch_0bV6FV0MNgTzlg', order.charge_id
  end

  test "#create_or_update_customer creates a customer" do
    coin_pack = CoinPack.make!
    user = User.make!

    mock(user).create_customer('tok_1')

    order = Order.new(user, coin_pack, 'tok_1')
    order.create_or_update_customer
  end

  test "#create_or_update_customer updates a customers card" do
    coin_pack = CoinPack.make!
    user = User.make!(customer_id: 'cus_1')

    customer = mock(Object.new)
    customer.card = 'tok_2'
    customer.save

    stub(Stripe::Customer).retrieve('cus_1') { customer }

    order = Order.new(user, coin_pack, 'tok_2')
    order.create_or_update_customer
  end

  test "#fulfill fails if #create_or_update_customer fails" do
    coin_pack = CoinPack.make!
    user = User.make!
    order = Order.new(user, coin_pack.id, 'tok_1')

    stub(order).create_or_update_customer { false }
    dont_allow(order).create_charge
    dont_allow(order).coin_user

    assert !order.fulfill, 'order completes'
  end

  test "#fulfill fails if #create_charge raises an error" do
    coin_pack = CoinPack.make!
    user = User.make!
    order = Order.new(user, coin_pack.id, 'tok_1')

    stub(order).create_or_update_customer { true }
    stub(order).create_charge { raise Stripe::StripeError }
    dont_allow(order).coin_user

    assert !order.fulfill, 'order completes'
  end

  test "#fulfill fails if #coin_user fails" do
    coin_pack = CoinPack.make!
    user = User.make!
    order = Order.new(user, coin_pack.id, 'tok_1')

    stub(order).create_or_update_customer { true }
    stub(order).create_charge { true }
    stub(order).coin_user { false }

    assert !order.fulfill, 'order completes'
  end

end
