require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test 'recognition of login and logout paths' do
    assert_routing({ path: '/login', method: :get },
      { controller: 'sessions', action: 'new' })

    assert_routing({ path: '/logout', method: :get },
      { controller: 'sessions', action: 'destroy' })
  end

  test 'GET new as HTML' do
    get :new

    assert_response :success

    assert_equal 'text/html', response.content_type

    assert_action_title 'Login'

    assert_form session_path, method: :post do
      assert_select 'input[type=?][name=?]', 'email', 'email'
      assert_select 'input[type=?][name=?]', 'password', 'password'
    end
  end

  test 'POST to create with valid data' do
    session[:return_path] = '/videos/new'

    post :create, email: @ringo.email, password: '123'

    assert_redirected_to '/videos/new'

    assert_equal 'text/html', response.content_type

    assert_equal @ringo.id, session[:user_id]
  end

  test 'POST to create with unexistent email' do
    post :create, email: 'unexistent@example.com', password: '123'

    assert_response :success

    assert_template :new

    assert_equal 'text/html', response.content_type

    assert_equal 'Invalid password or username', flash.alert

    assert_form session_path, method: :post
  end

  test 'POST to create with invalid password'  do
    post :create, email: @ringo.email, password: 'INVALID'

    assert_response :success

    assert_template :new

    assert_equal 'text/html', response.content_type

    assert_equal 'Invalid password or username', flash.alert

    assert_nil session[:user_id], 'User logged in with wrong password'
  end

  test 'DELETE to destroy' do
    delete :destroy

    assert_redirected_to '/'

    assert_equal 'text/html', response.content_type

    assert_nil session[:user_id], 'User not logged out properly'
  end
end
