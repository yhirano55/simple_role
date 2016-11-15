require "rails_helper"

RSpec.describe SimpleRole::Model::Resource, type: :model do
  describe ".build" do
    before do
      SimpleRole.configure do |config|
        config.using_active_admin = using_active_admin
      end
    end

    subject { described_class.build }

    context "when using_active_admin is true" do
      let(:using_active_admin) { true }
      it "should call from SimpleRole::Model::Resource::ActiveAdminResource" do
        expect_any_instance_of(described_class::ActiveAdminResource).to receive(:call).and_return(true)
        should be_truthy
      end
    end

    context "when using_active_admin is false" do
      let(:using_active_admin) { false }
      it "should call from SimpleRole::Model::Resource::ActiveRecordResource" do
        expect_any_instance_of(described_class::ActiveRecordResource).to receive(:call).and_return(true)
        should be_truthy
      end
    end
  end
end
