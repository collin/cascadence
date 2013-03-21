require 'simplecov'
require File.join File.expand_path("..", File.dirname(__FILE__)), "lib", "cascadence"

SimpleCov.start

module RSpec
  FixturePath = File.expand_path("../../fixtures", __FILE__)
end