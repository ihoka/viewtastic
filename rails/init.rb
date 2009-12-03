require File.join(File.dirname(__FILE__), *%w[.. lib viewtastic])
ActiveSupport::Dependencies.load_paths << File.join(Rails.root, *%w[app presenters])
