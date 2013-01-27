require 'spec_helper'

describe OrdersController do

  describe "#create" do

    it "authenticates users" do
      post :create
      expect(response).to authenticate_user
    end

  end



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
