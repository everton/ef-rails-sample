require 'test_helper'

class Admin::UsersControllerUnloggedTest < ActionController::TestCase
  setup { @controller = Admin::UsersController.new }

  should_require_login_for :get, :index

  should_require_login_for :get, :new

  should_require_login_for :get, :edit, id: 'XXX'

  should_require_login_for :put, :update, id: 'XXX'

  should_require_login_for :post, :create

  should_require_login_for :delete, :destroy, id: 'XXX'
end
