require 'simplecov'
require File.join File.expand_path("..", File.dirname(__FILE__)), "lib", "cascadence"

SimpleCov.start

module RSpec
  RootPath = File.expand_path "../../", __FILE__
  FixturePath = File.join RootPath, "fixtures"
end