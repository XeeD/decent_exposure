require 'decent_exposure/strategizer'
require 'decent_exposure/configuration'

module DecentExposure
  module Expose

    def self.extended(base)
      base.extend ConfigurationDSL
      base.class_eval do
        cattr_accessor :_default_exposure
        def _resources
          @_resources ||= {}
        end
        hide_action :_resources
      end
    end

    def _exposures
      @_exposures ||= {}
    end

    def default_exposure(&block)
      self._default_exposure = block
    end

    def expose(name, &block)
      _exposures[name] = _exposure = DecentExposure::Strategizer.new(name, exposure, _default_exposure, &block).strategy

      define_method(name) do
        return _resources[name] if _resources.has_key?(name)
        _resources[name] = _exposure.call(self)
      end

      helper_method name
      hide_action name
    end
  end

end
