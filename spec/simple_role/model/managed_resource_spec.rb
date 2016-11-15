require "rails_helper"

RSpec.describe SimpleRole::Model::ManagedResource, type: :model do
  describe "included" do
    subject { build(:managed_resource) }

    it { should have_many(:permissions).dependent(:destroy) }
    it { should validate_presence_of(:class_name) }
    it { should validate_presence_of(:action) }
  end

  describe "InstanceMethods" do
    describe "#const" do
      let(:instance) { build(:managed_resource, class_name: class_name) }
      subject { instance.const }

      context "when class_name is existing class" do
        let(:class_name) { "AdminUser" }
        it { should be ::AdminUser }
      end

      context "when class_name is not existing class" do
        let(:class_name) { "Alice" }
        it { should be_nil }
      end

      context "when class_name is nil" do
        let(:class_name) { nil }
        it { should be_nil }
      end
    end

    describe "#active?" do
      let(:instance) { build(:managed_resource, class_name: class_name) }
      subject { instance.active? }

      context "when class_name is existing class" do
        let(:class_name) { "AdminUser" }
        it { should be_truthy }
      end

      context "when class_name is not existing class" do
        let(:class_name) { "Alice" }
        it { should be_falsey }
      end

      context "when class_name is nil" do
        let(:class_name) { nil }
        it { should be_falsey }
      end
    end
  end

  describe "ClassMethods" do
    describe ".reload" do
      let(:manageable_resources) do
        [].tap do |arr|
          arr << attributes_for(:managed_resource, class_name: "AdminUser", action: "read")
          arr << attributes_for(:managed_resource, class_name: "AdminUser", action: "create")
          arr << attributes_for(:managed_resource, class_name: "AdminUser", action: "update")
          arr << attributes_for(:managed_resource, class_name: "AdminUser", action: "destroy")
        end
      end

      before do
        # for cleanup
        create(:managed_resource, class_name: "InvalidClass", name: "InvalidClass", action: "read")
        allow(::ManagedResource).to receive(:manageable_resources).and_return(manageable_resources)
      end

      subject { ::ManagedResource.reload }

      it { expect { should }.to change { ::ManagedResource.count }.from(1).to(4) }
      it { expect { should }.to change { ::Permission.count      }.from(0).to(4) }
    end
  end
end
