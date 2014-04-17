require 'simplecov'
SimpleCov.start :rails do
  minimum_coverage 100
end

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require_relative 'form_test_helper'
require_relative 'validation_test_helper'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  include ValidationTestHelper

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  self.use_instantiated_fixtures = true

  setup do
    @inline  = Resque.inline
    Resque.inline = true
  end

  teardown do
    Resque.inline = @inline
    FileUtils.rm_rf Rails.root.join 'public/videos/test/'
  end

  def grant_pre_processed_video_at_path!(video)
    FileUtils.mkdir_p Rails.root.join('public/videos/test/')

    src  = Rails.root.join('test/fixtures/videos/small-processed')
    dest = Rails.root.join("public/videos/test/#{video.id}")

    FileUtils.cp_r src, dest

    FileUtils.mv dest.join('small.mp4'), dest.join("#{video.id}.mp4")
    FileUtils.mv dest.join('small.ogg'), dest.join("#{video.id}.ogg")
  end
end

class ActionController::TestCase
  include FormTestHelper

  def login!(user)
    session[:user_id] = user.id
  end

  def http_login!(username, password)
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic
      .encode_credentials(username, password)
  end

  def assert_action_title(title)
    escaped_title = CGI.escape_html(title)

    assert_select 'title', "Videos Publication Example - #{escaped_title}"
    assert_select 'h1', title
  end

  def self.should_require_login_for(http_verb, action, options = {})
    test "login required to #{http_verb.to_s.upcase} to #{action}" do
      send(http_verb, action, options)

      assert_redirected_to '/login',
        "Protected action '#{action}' did not required login"
    end
  end

  def self.should_require_admin_for(http_verb, action, options = {})
    test "admin required to #{http_verb.to_s.upcase} to #{action}" do
      assert session[:user_id], 'You must loggin an user first'

      send(http_verb, action, options)

      assert_redirected_to '/',
        "Admin action '#{action}' did not required admin privileges"
    end
  end

  def self.should_get_with_success(action, call_params = {}, &block)
    test "GET #{action}" do
      action_title = call_params.delete :action_title

      call_params.each do |k, v|
        call_params[k] = instance_exec(&v) if v.is_a? Proc
      end

      get action, call_params

      assert_response :success

      assert_action_title action_title if action_title

      instance_eval &block if block_given?
    end
  end
end

class ActionDispatch::IntegrationTest
  include FormTestHelper
end
