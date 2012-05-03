require 'decent_exposure/configuration'

class ActiveRecordController
  extend DecentExposure::ConfigurationDSL
end

describe DecentExposure::ConfigurationDSL do
  describe "#exposure" do
    subject { ActiveRecordController.exposure }
    it { should be_kind_of(DecentExposure::Configuration) }
  end
end

describe DecentExposure::Configuration do
  context "#orm" do
    context "without config block" do
      subject { DecentExposure::Configuration.new }
      its(:orm) { should be(:active_record) }
    end

    context "when specifying :mongoid as the orm" do
      subject { DecentExposure::Configuration.new{ orm :mongoid } }
      its(:orm) { should be(:mongoid) }
    end
  end

  context "#options" do
    subject { DecentExposure::Configuration.new{ orm :super_orm }.options }
    it { should be_kind_of(Hash) }
    it "returns the configured options" do
      should == { orm: :super_orm }
    end
  end
end
