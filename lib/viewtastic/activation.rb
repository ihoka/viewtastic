module Viewtastic
  module Activation
    # Lets Viewtastic know about the controller object via a before filter, AKA "activates" viewtastic.
    # Borrowed from Authlogic.
    #
    def self.included(klass) # :nodoc:
      klass.prepend_before_filter :activate_viewtastic
    end
    
    private
      def activate_viewtastic
        Viewtastic::Base.controller = self
      end
  end
end
ActionController::Base.send(:include, Viewtastic::Activation)