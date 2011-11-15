ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.include Mongoid::Matchers
  config.include Factory::Syntax::Methods
  config.include Devise::TestHelpers, type: :controller
  
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  Fog.mock!
end

def fake_customer
  @@fake_customer ||= Struct.new(:id, :active_card).new(
    'cus_1', Struct.new(:type, :country, :exp_month, :exp_year, :last4).new('visa', 'US', 11, 2012, '4242')
  )
end

def expect_stripe_retrieve user
  Stripe::Customer.should_receive(:retrieve).with(user.stripe_id) { fake_customer }
end

def expect_stripe_create_with_plan user, plan, next_charge_date = '2011-12-04'
  Stripe::Customer.should_receive(:create).with(
    description: user.customer_description,
          email: user.email,
           plan: plan.id,
         coupon: nil,
           card: 'tok_12345'
  ) { Struct.new(:id, :next_recurring_charge, :active_card).new(
        'cus_1', 
        Struct.new(:date, :amount).new(next_charge_date, plan.price),
        Struct.new(:type, :country, :exp_month, :exp_year, :last4).new('visa', 'US', 11, 2012, '4242')
      )
    }
end

def expect_stripe_create user, token = 'tok_12345'
  Stripe::Customer.should_receive(:create).with(
    description: user.customer_description,
          email: user.email,
         coupon: nil,
           card: token
  ) { Struct.new(:id, :active_card).new(
        'cus_1', 
        Struct.new(:type, :country, :exp_month, :exp_year, :last4).new('visa', 'US', 11, 2012, '4242')
      )
    }
end

def expect_stripe_update user, plan, next_charge_date = '2011-12-04'
  user.customer.should_receive(:update_subscription).with(
        plan: plan.id,
      coupon: user.coupon,
        card: user.stripe_token,
     prorate: false
  )
end

def expect_stripe_charge user, amount 
  Stripe::Charge.should_receive(:create).with(
    :amount => amount,
    :currency => "usd",
    :customer => user.stripe_id,
    :description => "Minefold.com Fun plan"
  )
end

def set_initial_plan user, plan
  user.stub(:customer) { fake_customer }
  expect_stripe_update user, plan
  user.plan_id = plan.id
  user.stripe_id = 'cus_1'
end
