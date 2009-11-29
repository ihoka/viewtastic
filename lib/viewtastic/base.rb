class Viewtastic::Base
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::TagHelper
  
  class_inheritable_accessor :presented
  self.presented = []
  
  delegate :protect_against_forgery?,
           :request_forgery_protection_token,
           :form_authenticity_token,
           :dom_id,
           :to => :controller
  
  class << self    
    def presents(*types)
      types_and_attributes = types.extract_options!
    
      types_and_attributes.each do |name, delegates|
        attr_accessor name
        presented << name
        delegates.each do |msg|
          delegate msg, :to => name
        end
      end
    
      attr_accessor *types
      self.presented += types
      
      presented.each do |name|
        define_method("#{name}_dom_id") do |*args|
          send(:dom_id, send(name), *args)
        end
      end
    end
    
    def controller=(value)
      Thread.current[:viewtastic_controller] = value
    end
    
    def controller
      Thread.current[:viewtastic_controller]
    end
    
    def activated?
      !controller.nil?
    end
  end
  
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
  
  protected
    def controller
      self.class.controller
    end
  
    def delegate_message(method_name, *args, &block)
      presentable = presentable_for(method_name)
      send(presentable).send(flatten_attribute_name(method_name, presentable), *args, &block)
    end
    
    def presentable_for(method_name)
      presented.sort_by { |k| k.to_s.size }.reverse.detect do |type|
        method_name.to_s.starts_with?(attribute_prefix(type))
      end
    end
  
    def presented_attribute?(method_name)
      p = presentable_for(method_name)
      !p.nil? && send(p).respond_to?(flatten_attribute_name(method_name,p))
    end
    
    def flatten_attribute_name(name, type)
      name.to_s.gsub(/^#{attribute_prefix(type)}/, '')
    end
    
    def attribute_prefix(type)
      "#{type}_"
    end
end