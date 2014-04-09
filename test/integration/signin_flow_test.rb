require 'test_helper'

class SigninFlowTest < ActionDispatch::IntegrationTest
  fixtures :all

  test 'login to access video creation page' do
    get '/videos'

    assert_response :success

    assert_select 'a[href=?]', '/videos/new'

    assert_select 'a[href=?]', '/login', nil,
      'It did not presented the login link for unlogged user'

    get_via_redirect '/videos/new'

    assert_equal '/login', path

    assert_equal 'To access this page you must be logged', flash[:alert]

    assert_form '/session' do
      assert_select 'input[name=?]', 'email'
      assert_select 'input[name=?]', 'password'
    end

    post_via_redirect '/session', email: @george.email, password: '123'

    assert_equal '/videos/new', path

    assert_equal 'Welcome!', flash[:notice]

    assert_select 'a[href=?]', '/logout', nil,
      'It did not presented the logout link for logged user'
  end
end
