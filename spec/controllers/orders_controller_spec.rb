require 'spec_helper'

describe OrdersController do
  let(:dave) { User.create username: 'whatupdave',
                              email: 'dave@minefold.com',
                           password: 'carlsmum',
              password_confirmation: 'carlsmum'}

  let(:order) { Order.create user:dave}

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in dave
  end

  it "creates an order" do
    old_hours = dave.hours
    old_credit_events = dave.credit_events

    post :create, {"mc_gross"=>"12.00", "protection_eligibility"=>"Ineligible", "payer_id"=>"WBNKVTEY5L8Q2", "tax"=>"0.00", "payment_date"=>"16:44:30 Jul 19, 2011 PDT", "payment_status"=>"Completed", "charset"=>"windows-1252", "first_name"=>"Stephen", "option_selection1"=>"24", "mc_fee"=>"0.59", "notify_version"=>"3.1", "custom"=>order.id.to_s, "payer_status"=>"verified", "business"=>"christopher.lloyd@gmail.com", "quantity"=>"1", "verify_sign"=>"A3Y1IabViDnLM.hMAUvK-kr83JP5A9qt.ap4cnRGqvSrAkyZP5qd98AC", "payer_email"=>"steve@stevegilles.com", "option_name1"=>"Credits", "txn_id"=>"4GE09330VW8382013", "payment_type"=>"instant", "btn_id"=>"32658455", "last_name"=>"Gilles", "receiver_email"=>"christopher.lloyd@gmail.com", "payment_fee"=>"0.59", "shipping_discount"=>"0.00", "insurance_amount"=>"0.00", "receiver_id"=>"DDKMPSYFH2R4E", "txn_type"=>"web_accept", "item_name"=>"Minefold Credits", "discount"=>"0.00", "mc_currency"=>"USD", "item_number"=>"MF001", "residence_country"=>"AU", "handling_amount"=>"0.00", "shipping_method"=>"Default", "transaction_subject"=>order.id.to_s, "payment_gross"=>"12.00", "shipping"=>"0.00", "ipn_track_id"=>"CECUO59K4SKQCncYPT7EWg"}

    response.should be_success
  end
end