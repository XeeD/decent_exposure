require 'decent_exposure/strategizer'
require 'decent_exposure/active_record'

describe DecentExposure::Strategizer do
  let(:config) { double(orm: :active_record) }
  describe "#strategy" do
    subject { exposure.strategy }
    context "when a block is given" do
      let(:block) { lambda { "foo" } }
      let(:exposure) { DecentExposure::Strategizer.new("foobar", config, nil, &block) }
      it "saves the proc as the strategy" do
        subject.block.should == block
      end
    end
    context "with no block" do
      let(:exposure) do
        DecentExposure::Strategizer.new(name, config, block)
      end
      let(:block) do
        lambda { |name| name.upcase }
      end
      let(:name) { "foo" }
      context "and a default exposure" do
        it "has a name" do
          subject.name.should == name
        end
        it "passes the name to the block" do
          context = stub
          subject.call(context).should == "FOO"
        end
      end

      context "and no default exposure" do
        let(:exposure) { DecentExposure::Strategizer.new(name, config, nil) }
        let(:name) { "exposed" }

        it "invokes the ORMStrategy class" do
          DecentExposure::ORMStrategy.should_receive(:new).with(:active_record, name).and_return(double(instance: nil))
          exposure.strategy
        end
      end
    end
  end

  describe DecentExposure::ORMStrategy do
    describe "#class_constant" do
      subject { DecentExposure::ORMStrategy.new(orm, 'person').class_constant }

      context "when the specified orm is :active_record" do
        let(:orm) { :active_record }
        it { should be(DecentExposure::ActiveRecord) }
      end
    end

    describe "#instance" do
      let(:orm_strategy) { DecentExposure::ORMStrategy.new(:active_record, 'person') }
      subject { orm_strategy.instance }
      it { should be_kind_of(DecentExposure::ActiveRecord) }
    end
  end
end
