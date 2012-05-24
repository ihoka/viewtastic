module Viewtastic
  # Base class for presenters. See README.md for usage.
  #
  class Base
    include ActionView::Helpers::UrlHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::NumberHelper
    include ActionView::Helpers::FormTagHelper

    if Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR == 0
      class_inheritable_accessor :presented
    else
      class_attribute :presented
    end

    self.presented = []

    delegate :protect_against_forgery?,
             :request_forgery_protection_token,
             :form_authenticity_token,
             :dom_id,
             :to => :controller

    class << self
      # Indicates which models are to be presented.
      #
      #   class CommentPresenter < Viewtastic::Base
      #     presents :comment, :post
      #   end
      #
      # If you want to delegate messages to models without prefixing them with the model name, specify them in an Array:
      #
      #   class PresenterWithTwoAddresses < ActivePresenter::Base
      #     presents :post, :comment => [:body, :created_at]
      #   end
      #
      def presents(*types)
        types_and_attributes = types.extract_options!

        types_and_attributes.each do |name, delegates|
          attr_accessor name
          presented << name
          delegate *delegates.push(:to => name)
        end

        attr_accessor *types
        self.presented += types

        presented.each do |name|
          define_method("#{name}_dom_id") do |*args|
            controller.send(:dom_id, send(name), *args)
          end
        end
      end

      def controller=(value) #:nodoc:
        Thread.current[:viewtastic_controller] = value
      end

      def controller #:nodoc:
        Thread.current[:viewtastic_controller]
      end

      def activated? #:nodoc:
        !controller.nil?
      end
    end

    # Accepts arguments in two forms. If you had a CommentPresenter that presented a Comment model and a Post model, you would write the follwoing:
    #
    # 1. CommentPresenter.new(:comment => Comment.new, :post => @post)
    # 2. CommentPresenter.new(Comment.new, @post) - it will introspect on the model's class; the order is not important.
    #
    # You can even mix the two:
    #   CommentPresenter.new(Comment.new, :post => @post)
    #
    def initialize(*values)
      keys_and_values = values.extract_options!

      keys_and_values.each do |name, instance|
        send("#{name}=", instance)
      end

      values.each do |value|
        send("#{value.class.name.underscore}=", value)
      end
    end

    def method_missing(method_name, *args, &block)
      if method_name.to_s =~ /_(path|url)$/
        # Delegate all named routes to the controller
        controller.send(method_name, *args)
      elsif presented_attribute?(method_name)
        delegate_message(method_name, *args, &block)
      else
        super
      end
    end

    # The current controller performing the request is accessible with this.
    #
    def controller
      self.class.controller
    end

    protected
      def delegate_message(method_name, *args, &block) #:nodoc:
        presentable = presentable_for(method_name)
        send(presentable).send(flatten_attribute_name(method_name, presentable), *args, &block)
      end

      def presentable_for(method_name) #:nodoc:
        presented.sort_by { |k| k.to_s.size }.reverse.detect do |type|
          method_name.to_s.starts_with?(attribute_prefix(type))
        end
      end

      def presented_attribute?(method_name) #:nodoc:
        p = presentable_for(method_name)
        !p.nil? && send(p).respond_to?(flatten_attribute_name(method_name,p))
      end

      def flatten_attribute_name(name, type) #:nodoc:
        name.to_s.gsub(/^#{attribute_prefix(type)}/, '')
      end

      def attribute_prefix(type) #:nodoc:
        "#{type}_"
      end
  end
end
