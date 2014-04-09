require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup { login! @george } # George is admin, see fixtures...

  test 'GET index' do
    get :index

    assert_response :success

    assert_action_title 'Users'

    assert_select 'a[href=?]', new_admin_user_path, 'New User'

    assert_select 'ol#users' do |ul|
      assert_select 'li', 4 # users from fixtures

      User.all.each do |user|
        assert_select 'li a[href=?]', edit_admin_user_path(user),
          count: 1, text: ERB::Util.h(user.email)

        assert_form admin_user_path(user), method: :delete do
          assert_select 'input[type=?][value=?]',
            'submit', 'Delete User'
        end
      end
    end
  end

  test 'GET edit logged' do
    get :edit, id: @john.to_param

    assert_response :success

    assert_action_title "Edit - #{@john.email}"

    assert_form admin_user_path(@john), method: :put do
      assert_select 'input[type=?][name=?][value=?]',
        'email', 'user[email]', @john.email

      assert_select 'input[type=?][name=?][value=?]',
        'hidden', 'user[admin]', 0
      assert_select 'input[type=?][name=?][value=?]',
        'checkbox', 'user[admin]', 1

      assert_select 'input[type=?][name=?]',
        'password', 'user[password]'
    end
  end

  test 'PUT to update' do
    assert_no_difference 'User.count' do
      put(:update, id: @john.to_param, user: {
            email: 'new_john_email@example.com',
            admin: true
          })
    end

    assert_redirected_to admin_users_path

    assert_equal 'text/html', response.content_type

    assert_equal 'new_john_email@example.com', @john.reload.email
    assert @john.reload.admin?, 'admin checkbox ignored'
  end

  test 'PUT invalid parameters to update' do
    assert_no_difference 'User.count' do
      put(:update, id: @john.to_param, user: {
            email: '   '
          })
    end

    assert_response :success
    assert_template :edit

    assert_action_title "Edit - #{@john.email}"

    assert_form admin_user_path(@john), method: :put do
      assert_select '#error_explanation' do
        assert_select 'li', ERB::Util.h("Email can't be blank")
      end
    end
  end

  test 'GET new' do
    get :new

    assert_response :success

    assert_action_title 'New User'

    assert_form admin_users_path, method: :post do
      assert_select 'input[type=?][name=?]',
        'email', 'user[email]'

      assert_select 'input[type=?][name=?][value=?]',
        'hidden', 'user[admin]', 0
      assert_select 'input[type=?][name=?][value=?]',
        'checkbox', 'user[admin]', 1

      assert_select 'input[type=?][name=?]',
        'password', 'user[password]'
    end
  end

  test 'POST to create' do
    assert_difference 'User.count' do
      post :create, user: {
        email: 'new_test_user@example.com',
        admin: true, password: '123'
      }
    end

    assert_redirected_to admin_users_path

    new_user = User.where(email: 'new_test_user@example.com').first

    assert_equal 'new_test_user@example.com', new_user.email
    assert new_user.admin?, 'admin checkbox ignored'
    assert new_user.authenticate('123'), 'password not encrypted properly'
  end

  test 'POST invalid parameters to create' do
    assert_no_difference 'User.count' do
      post :create, user: {
        email: '   ', admin: true, password: '123'
      }
    end

    assert_response :success
    assert_template :new

    assert_action_title 'New User'

    assert_form admin_users_path do
      assert_select '#error_explanation' do
        assert_select 'li', ERB::Util.h("Email can't be blank")
      end
    end
  end

  test 'DELETE to destroy' do
    delete :destroy, id: @john.to_param

    assert_redirected_to admin_users_path

    assert_raises ActiveRecord::RecordNotFound do
      User.find @john.id
    end
  end
end
