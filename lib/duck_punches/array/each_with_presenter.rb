class Array
  # Wrap each element in the Array with a presenter specified by @presenter_class@ and 
  # assigned as the model for @object_name@.
  # @presenter_options@ are set once on the initial presenter instance.
  #
  def each_with_presenter(presenter_class, object_name, presenter_options={}, &block)
    presenter = presenter_class.new(presenter_options)
    each do |object|
      presenter.send("#{object_name}=", object)
      yield presenter
    end
  end
end
