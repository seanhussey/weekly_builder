require 'test/unit'
require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'action_pack'
require 'action_controller'
require 'action_view'
require 'action_controller/test_process'
require 'shoulda'
require 'mocha'

require 'lib/weekly_calendar'

require(File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'weekly_calendar/builder')))
