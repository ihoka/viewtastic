module Viewtastic
  module TestCase
    include Authlogic::TestCase

    def activate_viewtastic
      if @request && ! @request.respond_to?(:params)
        class <<@request
          alias_method :params, :parameters
        end
      end

      Viewtastic::Base.controller = (@request && Authlogic::TestCase::RailsRequestAdapter.new(@request)) || controller
    end
  end
end