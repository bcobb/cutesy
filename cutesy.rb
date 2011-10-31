class Cutesy

  class << self

    def klass(klass)
      cutesy = new(klass)
      yield cutesy

      cutesy.build!
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
    @setters_by_attribute = {}
  end

  def sets(attribute, options = {})
    cute_attribute = CuteAttribute.new(@klass, attribute)

    @setters_by_attribute[cute_attribute] = options[:with]
  end

  def build!
    attributes = @setters_by_attribute

    @klass.class_eval do
      attributes.each do |attribute, setter|

        define_method(setter) do |value|
          tap { |object| attribute.set!(object, value) }
        end

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
