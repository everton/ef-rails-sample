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

  def assert_action_title(title)
    escaped_title = CGI.escape_html(title)

    assert_select 'title', "Videos Publication Example - #{escaped_title}"
    assert_select 'h1', title
  end

  def assert_login_required_for(http_verb, action, options = {})
    send(http_verb, action, options)

    assert_redirected_to '/login',
      "Protected action '#{action}' did not required login"
  end

  def assert_admin_required_for(http_verb, action, options = {})
    send(http_verb, action, options)

    assert session[:user_id], 'You must loggin an user first'

    assert_redirected_to '/',
      "Admin action '#{action}' did not required admin privileges"
  end
end

class ActionDispatch::IntegrationTest
  include FormTestHelper
end
