module Clerq

  module Properties
    def property(name, options = {}, &validation)
      default_value = options[:default]
      define_method name do
        v = instance_variable_get("@#{name}")
        v = default_value unless v
        v
      end

      define_method "#{name}=" do |val|
        if validation && !validation.call(val)
          raise ArgumentError, "Invalid property value #{name}: #{val}"
        end
        instance_variable_set("@#{name}", val)
      end
    end
  end

end
