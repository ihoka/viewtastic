class Array
  def each_with_presenter(presenter_class, object_name, presenter_options={}, &block)
    presenter = presenter_class.new(presenter_options)
    each do |object|
      presenter.send("#{object_name}=", object)
      yield presenter
    end
  end
end
