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


def expect_stripe_create user, plan, next_charge_date = '2011-12-04'
  Stripe::Customer.should_receive(:create).with(
    description: user.customer_description,
          email: user.email,
           plan: plan.stripe_id,
         coupon: nil,
           card: 'tok_12345'
  ) { Struct.new(:id, :next_recurring_charge).new('cus_1', Struct.new(:date, :amount).new(next_charge_date, plan.price)) }
end

def expect_stripe_update user, plan, next_charge_date = '2011-12-04'
  customer = double("Stripe::Customer")
  customer.stub(:next_recurring_charge) { Struct.new(:date, :amount).new(next_charge_date, plan.price) }
  
  Stripe::Customer.should_receive(:retrieve).with(user.stripe_id) { customer }
  
  customer.should_receive(:update_subscription).with(
        plan: plan.stripe_id,
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

def set_plan user, plan
  expect_stripe_create user, Plan.pro
  user.plan = Plan.pro.stripe_id
  user.stripe_token = 'tok_12345'
end
