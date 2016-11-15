require "rails_helper"

RSpec.describe SimpleRole do
  it "has a version number" do
    expect(SimpleRole::VERSION).not_to be nil
  end

  describe ".configure" do
    subject do
      described_class.configure do |config|
        config.using_active_admin = false
      end
    end

    it { expect { subject }.not_to raise_error }
  end

  describe ".config" do
    subject { described_class.config }
    it { should be_a described_class::Config }
  end
end
