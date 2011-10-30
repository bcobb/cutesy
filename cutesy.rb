class Cutesy

  class << self

    def klass(klass)
      yield new(klass)
    end

    def template(klass = nil, attribute = nil, &block)
      template = template_key(klass, attribute)

      if template.any?
        templates[template] = block
      else
        templates.default = block
      end
    end

    def template_for(klass, attribute)
      attribute_template = template_key(klass, attribute)
      class_template = template_key(klass, nil)

      templates[attribute_template] || templates[class_template]
    end

    def reset!
      @templates = nil
    end

    private

    def templates
      @templates ||= {}
    end

    def template_key(*args)
      return args
    end

  end

  def initialize(klass)
    @klass = klass
  end

  def sets(attribute, options = {})
    cute_setter = options[:with]
    cute_attribute = CuteAttribute.new(@klass, attribute)

    @klass.class_eval do

      define_method(cute_setter) do |value|
        tap { |object| cute_attribute.set!(object, value) }
      end

    end
  end

end

class CuteAttribute

  def initialize(klass, attribute)
    @klass = klass
    @attribute = attribute
  end

  def set!(object, value)
    template.call(object, @attribute, value)
  end

  def template
    Cutesy.template_for(@klass, @attribute) || default_template
  end

  private

  def default_template
    lambda do |object, attribute, value|
      begin
        object.send(setter, value)
      rescue NoMethodError => e
        object.instance_variable_set(instance_variable, value)
      end
    end
  end

  def setter
    return (@attribute.to_s + '=').to_sym
  end

  def instance_variable
    return ('@' + @attribute.to_s).to_sym
  end

end
