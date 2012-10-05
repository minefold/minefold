require 'test_helper'

class RandomMailer; end

class UserTest < ActiveSupport::TestCase

  test "#name" do
    user = User.new(first_name: 'Chris', last_name: 'Lloyd')
    assert_equal 'Chris Lloyd', user.name
  end

  test "#minecraft_linked?" do
    user = User.make!
    minecraft = Game.make!(:minecraft)

    assert !user.minecraft_linked?, 'minecraft account is linked'

    user.players.create(game: minecraft, uid: 'test')

    assert user.minecraft_linked?, 'minecraft account is not linked'
  end
  
  test "#facebook_linked?" do
    user = User.new
    assert !user.facebook_linked?, 'facebook account is linked'
    user.facebook_uid = 'chrsllyd'
    assert user.facebook_linked?, 'facebook account is not linked'
  end

  test "#find_for_database_authentication" do
    user = User.make!
    assert_equal user,
      User.find_for_database_authentication(email_or_username: user.username)

    assert_equal user,
      User.find_for_database_authentication(email_or_username: user.email)

    assert !User.find_for_database_authentication(email_or_username: 'blerg')
    assert !User.find_for_database_authentication(email_or_username: 'blerg@example.com')
  end

  test "#find_or_create_for_facebook" do
  end

  test "#channel_key" do
    user = User.new
    mock(user).id { 'foo' }
    assert_equal 'user-foo', user.channel_key
  end

  test "#private_channel_key" do
    user = User.new
    mock(user).id { 'foo' }
    assert_equal 'private-user-foo', user.private_channel_key
  end

  test "#customer" do
    user = User.make!
    assert_equal nil, user.customer

    user.customer_id = 'cus_1'
    mock(Stripe::Customer).retrieve('cus_1') { 'Stripe::Customer' }
    assert_equal 'Stripe::Customer', user.customer
  end

  test "#create_customer" do
    user = User.make!
    mock(Stripe::Customer).create(
      card: 'tok_1',
      email: user.email,
      description: user.id.to_s
    ) { stub(Object.new).id { 'cus_1'} }

    user.create_customer('tok_1')

    assert_equal 'cus_1', user.customer_id
  end

  test "#increment_credits!" do
    user = User.make!
    user.credits = 10
    user.save

    user.increment_credits!(10)
    # This test is because increment_cr! is fire and forget. Being atomic it
    # doesn't update the model's own data without force reloading it.
    assert_equal 10, user.credits

    user.reload
    assert_equal 20, user.credits
  end

  test "#increment_credits! works atomically" do
    user = User.make!
    user.credits = 0
    user.save
    same_user = User.find(user.id)

    user.increment_credits! 1
    same_user.increment_credits! 1

    user.reload
    assert_equal 2, user.credits
  end
  
  test "#wants_mail_for?" do
    user = User.new

    assert_equal false, user.wants_mail_for?(RandomMailer)

    user.mail_prefs[:random_mailer] = true

    assert_equal true, user.wants_mail_for?(RandomMailer)
  end

end
