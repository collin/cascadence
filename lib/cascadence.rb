require "thor"
require "daemons"
require "active_support/core_ext/string"
require "active_support/core_ext/module"
require "singleton"
module Cascadence
  autoload :Stateful, File.join( File.dirname(__FILE__), "cascadence", "stateful" )
  autoload :ClassMethods, File.join( File.dirname(__FILE__), "cascadence", "class_methods" )
  autoload :Flow, File.join( File.dirname(__FILE__), "cascadence", "flow" )
  autoload :Helper, File.join( File.dirname(__FILE__), "cascadence", "helper")
  autoload :Commander, File.join( File.dirname(__FILE__), "cascadence", "commander")
  autoload :Confluence, File.join( File.dirname(__FILE__), "cascadence", "confluence")
  autoload :Runner, File.join( File.dirname(__FILE__), "cascadence", "runner")
  autoload :Config, File.join( File.dirname(__FILE__), "cascadence", "config")
  autoload :Task, File.join( File.dirname(__FILE__), "cascadence", "task")
  def self.config(&block)
    if block_given?
      yield Config.instance
    else
      Config.instance
    end
  end 

  def self.runner
    Runner.instance
  end
end