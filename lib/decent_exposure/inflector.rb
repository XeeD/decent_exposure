require 'active_support/inflector'
require 'active_support/core_ext/string/inflections'

module DecentExposure
  class Inflector
    attr_reader :original

    def initialize(name)
      @original = name.to_s
    end

    def namespaced_constant
      "DecentExposure::#{class_name}".constantize
    end

    def constant
      class_name.constantize
    end

    def class_name
      original.classify
    end

    def parameter
      singular + "_id"
    end

    def singular
      original.parameterize
    end

    def plural
      original.pluralize
    end
    alias collection plural

    def plural?
      plural == original
    end
  end
end
