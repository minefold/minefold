require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  
  test "GET #new unauthenticated" do
    get :new
    assert_unauthenticated_response
  end
  
  test "GET #new" do
    user = User.make!
    sign_in(user)
    
    get :new
    assert_response :success
  end
  
  test "POST #create unauthenticated" do
    post :create
    assert_unauthenticated_response
  end

  test "POST #create with invalid params" do
    credit_pack = CreditPack.make!
    user = User.make!

    sign_in(user)
    post :create
    assert_response :payment_required

    post :create, stripe_token: 'tok_1'
    assert_response :payment_required

    post :create, credit_pack_id: credit_pack.id + 1
    assert_response :payment_required
  end

  test "POST #create with new customer" do
    credit_pack = CreditPack.make!
    user = User.make!

    any_instance_of(Order) do |o|
      stub(o).create_or_update_customer { true }
      stub(o).create_charge { true }
    end

    sign_in(user)
    post :create, credit_pack_id: credit_pack.id, stripe_token: 'tok_1'

    assert_redirected_to user_root_path
  end

  test "POST #create with existing customer" do
    credit_pack = CreditPack.make!
    user = User.make!(customer_id: 'cus_1')

    any_instance_of(Order) do |o|
      stub(o).create_or_update_customer { true }
      stub(o).create_charge { true }
    end

    sign_in(user)
    post :create, credit_pack_id: credit_pack.id
    assert_redirected_to user_root_path
  end

  test "POST #create with existing customer and new card" do
    credit_pack = CreditPack.make!
    user = User.make!(customer_id: 'cus_1')

    any_instance_of(Order) do |o|
      stub(o).create_or_update_customer { true }
      stub(o).create_charge { true }
    end

    sign_in(user)
    post :create, credit_pack_id: credit_pack.id, stripe_token: 'tok_1'
    assert_redirected_to user_root_path
  end

end
