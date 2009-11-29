begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base app."
  exit
end

begin
  require 'authlogic/test_case'
rescue LoadError
  puts "You need to install the authlogic gem in your base app."
  exit
end

plugin_spec_dir = File.dirname(__FILE__)
ActiveRecord::Base.logger = Logger.new(plugin_spec_dir + "/debug.log")

databases = YAML::load(IO.read(plugin_spec_dir + "/db/database.yml"))
ActiveRecord::Base.establish_connection(databases[ENV["DB"] || "sqlite3"])

ActiveRecord::Schema.verbose = false
load(File.join(plugin_spec_dir, "db", "schema.rb"))

class User < ActiveRecord::Base; end

class UserPresenter < Viewtastic::Base
  presents :user => [ :login ]
end

Spec::Runner.configure do |config|
  include Authlogic::TestCase
  
  def activate_viewtastic
    if @request && ! @request.respond_to?(:params)
      class <<@request
        alias_method :params, :parameters
      end
    end

    Viewtastic::Base.controller = (@request && Authlogic::TestCase::RailsRequestAdapter.new(@request)) || controller
  end
  
  config.before(:each) do
    activate_viewtastic
  end
end