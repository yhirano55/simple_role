require "rails_helper"

RSpec.describe SimpleRole::Config do
  describe '.initialize' do
    subject { described_class.new }
    it { expect { subject }.not_to raise_error }
    it { should be_a described_class }
  end

  describe "#permission_state" do
    let(:config) { described_class.new }
    subject { config.permission_state }

    context "when default_state is :enabled" do
      before { config.default_state = :enabled }
      it { is_expected.to eq :enabled }
    end

    context "when default_state is :disabled" do
      before { config.default_state = :disabled }
      it { is_expected.to eq :disabled }
    end
  end
end
