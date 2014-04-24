require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'default user creation' do
    user = User.new email: 'test_user@example.com',
      password: '123', password_confirmation: '123'

    assert_difference -> { User.count } do
      user.save
    end

    assert user.authenticate('123'), 'Password not encrypted properly'

    refute user.admin?, 'Regular user created as admin'
  end

  test 'password authentication of users already created' do
    assert @george.authenticate('123'),
      'Can not authenticate user with proper password'
  end

  test 'destroy existing User and associated Videos' do
    assert_difference -> { User.count }, -1 do
      assert_difference -> { Video.count }, -2 do
        @john.destroy
      end
    end
  end

  test 'avoid blank email' do
    assert_bad_value User, :email, '   ', :blank
  end

  test 'avoid users with duplicated email' do
    assert_bad_value User, :email, @john.email, :taken
  end

  test 'avoid blank password' do
    assert_bad_value User, :password,              '   ', :blank
    assert_bad_value User, :password_confirmation, '   ', :blank
  end

  test 'ask for password confirmation' do
    user = User.new password: '123'

    emsg = error_message_for(:confirmation, attribute: 'Password')

    assert_bad_value user, :password_confirmation, '321', emsg
  end
end
