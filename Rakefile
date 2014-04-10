# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'resque/tasks'

VideoPublicationExample::Application.load_tasks

STATS_DIRECTORIES << ['Background Jobs', Rails.root.join('app/jobs')]
