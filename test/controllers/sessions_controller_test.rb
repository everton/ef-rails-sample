require 'test_helper'

# For common login flow see: test/integration/signin_flow_test.rb
class SessionsControllerTest < ActionController::TestCase
  test 'POST to create with unexistent email' do
    post :create, email: 'unexistent@example.com', password: '123'

    assert_response :success

    assert_template :new

    assert_equal 'Invalid password or username', flash.alert

    assert_form session_path, method: :post
  end

  test 'POST to create with invalid password'  do
    post :create, email: @ringo.email, password: 'INVALID'

    assert_response :success

    assert_template :new

    assert_equal 'Invalid password or username', flash.alert

    assert_nil session[:user_id], 'User logged in with wrong password'
  end
end
