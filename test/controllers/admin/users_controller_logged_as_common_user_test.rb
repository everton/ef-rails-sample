require 'test_helper'

class Admin::UsersControllerLoggedAsCommonUserTest < ActionController::TestCase
  setup do
    @controller = Admin::UsersController.new
    login! @john
  end

  should_require_admin_for :get, :index

  should_require_admin_for :get, :new

  should_require_admin_for :post, :create

  should_require_admin_for :get, :edit, id: 'XXX'

  should_require_admin_for :put, :update, id: 'XXX'

  should_require_admin_for :delete, :destroy, id: 'XXX'
end
