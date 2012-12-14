require 'spec_helper'

describe OrdersController do

#   setup do
#     @coin_pack = CoinPack.make!
#
#     @card = Stripe::Token.create(card: {
#         number: StripeCards[:default],
#         exp_month: Time.now.month,
#         exp_year: 1.year.from_now.year,
#         cvc: 123,
#         name: Faker::Name.name
#       })
#
#     @charge = Stripe::Charge.create(
#       amount: @coin_pack.cents,
#       currency: 'usd',
#       card: @card.id
#     )
#   end
#
#
# # --
#
#
#   test "POST #create unauthenticated" do
#     post :create
#     assert_unauthenticated_response
#   end
#
#   test "POST #create with invalid params" do
#     user = User.make!
#
#     sign_in(user)
#     post :create
#     assert_response :payment_required
#
#     post :create, stripe_token: @card.id
#     assert_response :payment_required
#
#     post :create, coin_pack_id: @coin_pack.id + 1
#     assert_response :payment_required
#   end
#
#   test "POST #create with new customer" do
#     user = User.make!
#
#     any_instance_of(Order) do |o|
#       stub(o).create_or_update_customer { true }
#       stub(o).create_charge { @charge }
#       stub(o).charge_id { @charge.id }
#     end
#
#     sign_in(user)
#     @request.env['HTTP_REFERER'] = user_root_url
#
#     post :create, coin_pack_id: @coin_pack.id, stripe_token: @card.id
#
#     assert_redirected_to order_path(id: @charge.id)
#   end
#
#   test "POST #create with existing customer" do
#     user = User.make!(customer_id: 'cus_1')
#
#     any_instance_of(Order) do |o|
#       stub(o).create_or_update_customer { true }
#       stub(o).create_charge { @charge }
#       stub(o).charge_id { @charge.id }
#     end
#
#     sign_in(user)
#     @request.env['HTTP_REFERER'] = user_root_url
#
#     post :create, coin_pack_id: @coin_pack.id
#     assert_redirected_to order_path(id: @charge.id)
#   end
#
#   test "POST #create with existing customer and new card" do
#     user = User.make!(customer_id: 'cus_1')
#
#     any_instance_of(Order) do |o|
#       stub(o).create_or_update_customer { true }
#       stub(o).create_charge { @charge }
#       stub(o).charge_id { @charge.id }
#     end
#
#     sign_in(user)
#     @request.env['HTTP_REFERER'] = user_root_url
#
#     post :create, coin_pack_id: @coin_pack.id, stripe_token: @card.id
#     assert_redirected_to order_path(id: @charge.id)
#   end

end
