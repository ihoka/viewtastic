require File.join(File.dirname(__FILE__), *%w[.. lib viewtastic])

if Rails.version >= '2.3.9'
  ActiveSupport::Dependencies.autoload_paths
else
  ActiveSupport::Dependencies.load_paths
end << File.join(Rails.root, *%w[app presenters])
