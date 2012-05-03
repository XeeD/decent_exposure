module DecentExposure
  module ConfigurationDSL
    def exposure(&block)
      @decent_config ||= DecentExposure::Configuration.new(&block)
    end
  end

  class Configuration
    def initialize(&block)
      instance_exec(&block) if block_given?
    end

    def options
      { orm: orm }
    end

    def orm(val=nil)
      @orm = val if val
      @orm || :active_record
    end
  end
end
