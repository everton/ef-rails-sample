require 'test_helper'

class Admin::UsersControllerUnloggedTest < ActionController::TestCase
  setup { @controller = Admin::UsersController.new }

  test 'admin actions requires logged user' do
    assert_login_required_for :get, :index

    assert_login_required_for :get, :new

    assert_login_required_for :get, :edit, id: @john.to_param

    assert_login_required_for :put, :update, id: @john.to_param, user: {
      email: 'new_john_email@example.com'
    }

    assert_login_required_for :post, :create, user: {
      email: 'new_test_user@example.com',
      admin: true, password: '123'
    }

    assert_login_required_for :delete, :destroy, id: @john.to_param
  end
end
