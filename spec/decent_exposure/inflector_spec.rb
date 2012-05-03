require 'decent_exposure/inflector'

class Fox; end
class DecentExposure::Fox; end

describe DecentExposure::Inflector do
  describe "#class_name" do
    let(:name) { "fox" }
    let(:inflector) { DecentExposure::Inflector.new(name) }
    it "returns a string form of the class name from that word" do
      inflector.class_name.should == 'Fox'
    end
  end

  describe "#constant" do
    let(:name) { "fox" }
    let(:inflector) { DecentExposure::Inflector.new(name) }
    it "returns a constant from that word" do
      inflector.constant.should == Fox
    end
  end

  describe "#namespaced_constant" do
    let(:name) { "fox" }
    let(:inflector) { DecentExposure::Inflector.new(name) }
    it "returns a namespaced constant from that word" do
      inflector.namespaced_constant.should == DecentExposure::Fox
    end
  end

  describe "#parameter" do
    let(:name) { "fox" }
    let(:inflector) { DecentExposure::Inflector.new(name) }
    it "returns a string of the form 'word_id'" do
      inflector.parameter.should == "fox_id"
    end
  end

  describe "#plural" do
    let(:inflector) { DecentExposure::Inflector.new(name) }
    subject { inflector.plural? }

    context "with a plural word" do
      let(:name) { "cars" }
      it { should be_true }
    end

    context "with a singular word" do
      let(:name) { "car" }
      it { should be_false }
    end
  end
end
