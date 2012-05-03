require 'decent_exposure/active_record'

module DecentExposure
  class Strategizer
    attr_reader :name, :block, :configuration, :default_exposure
    def initialize(name, configuration, default_exposure)
      @name, @configuration, @default_exposure =  name, configuration, default_exposure
      @block = Proc.new if block_given?
    end

    def strategy
      if block
        BlockStrategy.new(block)
      elsif default_exposure
        DefaultStrategy.new(name, default_exposure)
      else
        ORMStrategy.new(configuration.orm, name).instance
      end
    end
  end

  class DefaultStrategy < Struct.new(:name, :block)
    def call(controller)
      controller.instance_exec(name, &block)
    end
  end

  class ORMStrategy
    attr_reader :orm, :name
    def initialize(orm,name)
      @orm, @name = orm, name
    end

    def class_constant
      DecentExposure::Inflector.new(orm).namespaced_constant
    end

    def instance
      class_constant.new(name)
    end
  end

  class BlockStrategy
    attr_reader :block
    def initialize(block)
      @block = block
    end
    def call(controller)
      controller.instance_eval(&block)
    end
  end
end
