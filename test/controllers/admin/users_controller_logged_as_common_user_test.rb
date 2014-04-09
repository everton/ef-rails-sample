require 'test_helper'

class Admin::UsersControllerLoggedAsCommonUserTest < ActionController::TestCase
  setup do
    @controller = Admin::UsersController.new
    login! @john
  end

  test 'admin actions requires logged user with admin privileges' do
    assert_admin_required_for :get, :index

    assert_admin_required_for :get, :edit, id: @john.to_param

    assert_admin_required_for :put, :update, id: @john.to_param, user: {
      email: 'new_john_email@example.com'
    }

    assert_admin_required_for :get, :new

    assert_admin_required_for :post, :create, user: {
      email: 'new_test_user@example.com',
      admin: true, password: '123'
    }

    assert_admin_required_for :delete, :destroy, id: @john.to_param
  end
end
