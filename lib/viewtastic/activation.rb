module Viewtastic
  module Activation
    # Lets Viewtastic know about the controller object via a before filter, AKA "activates" viewtastic.
    # Borrowed from Viewtastic.
    #
    def self.included(klass) # :nodoc:
      if defined?(::ApplicationController)
        raise "Viewtastic is trying to prepend a before_filter in ActionController::Base to active itself" +
          ", the problem is that ApplicationController has already been loaded meaning the before_filter won't get copied into your" +
          " application. Generally this is due to another gem or plugin requiring your ApplicationController prematurely, such as" +
          " the resource_controller plugin. The solution is to require Viewtastic before these other gems / plugins. Please require" +
          " viewtastic first to get rid of this error."
      end
      
      klass.prepend_before_filter :activate_viewtastic
    end
    
    private
      def activate_viewtastic
        Viewtastic::Base.controller = self
      end
  end
end
