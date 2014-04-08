require 'simplecov'
SimpleCov.start :rails do
  minimum_coverage 100
end

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require_relative 'form_test_helper'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  setup do
    @inline  = Resque.inline
    Resque.inline = true
  end

  teardown do
    Resque.inline = @inline
    FileUtils.rm_rf Rails.root.join 'public/videos/test/'
  end
end

class ActionController::TestCase
  include FormTestHelper
end
