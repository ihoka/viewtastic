begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base app."
  exit
end

begin
  # We use the testing mocks from Authlogic because Viewtastic's "activation" code
  # is similar to the one Authlogic uses to get access to the controller.
  require 'authlogic/test_case'
rescue LoadError
  puts "You need to install the authlogic gem in your base app."
  exit
end

plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

databases = YAML::load(IO.read(plugin_spec_dir + "/db/database.yml"))
ActiveRecord::Base.establish_connection(databases[ENV["DB"] || "viewtastic"])

ActiveRecord::Schema.verbose = false
load(File.join(plugin_spec_dir, "db", "schema.rb"))

class User < ActiveRecord::Base; end

class UserPresenter < Viewtastic::Base
  presents :user => [ :login ]
  attr_accessor :foo
end

Spec::Runner.configure do |config|
  include Viewtastic::TestCase
  
  config.before(:each) do
    activate_viewtastic
  end
end