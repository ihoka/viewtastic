require 'rails'
require "viewtastic/activation"
require "viewtastic/base"

module Viewtastic
  VERSION = "0.3.0"

  class Railtie < Rails::Railtie
    initializer "viewtastic.activate" do
      ActiveSupport.on_load(:action_controller) do
        ActionController::Base.send(:include, Viewtastic::Activation)
      end
    end

    initializer "viewtastic.add_presenter_paths" do
      require "duck_punches/array/each_with_presenter"
    end
  end
end
