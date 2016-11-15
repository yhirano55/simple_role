require "rails_helper"

RSpec.describe SimpleRole::Model::Permission, type: :model do
  describe "included" do
    let(:managed_resource) { create(:managed_resource) }
    subject(:permission) { create(:permission, managed_resource: managed_resource) }

    it { should define_enum_for(:state).with({ disabled: 0, enabled: 1 })}
    it { should belong_to(:managed_resource) }
    it { should delegate_method(:class_name).to(:managed_resource) }
    it { should delegate_method(:action).to(:managed_resource) }
    it { should delegate_method(:name).to(:managed_resource) }
    it { should delegate_method(:const).to(:managed_resource) }
    it { should delegate_method(:active?).to(:managed_resource) }
    it { should delegate_method(:clear_cache).to(:class) }
    it { should validate_presence_of(:managed_resource) }
    it { should validate_presence_of(:state) }
    it { should validate_uniqueness_of(:managed_resource_id).scoped_to(:role) }

    it 'should run :clear_cache after update' do
      expect(permission).to receive(:clear_cache).once
      permission.enabled!
    end
  end

  describe "InstanceMethods" do
    describe "#ability" do
      let(:permission) { build(:permission, state: state) }
      subject { permission.ability }

      context "when state is :enabled" do
        let(:state) { :enabled }
        it { should eq :can }
      end

      context "when state is :disabled" do
        let(:state) { :disabled }
        it { should eq :cannot }
      end
    end
  end

  describe "ClassMethods" do
    let(:managed_resources) do
      [].tap do |arr|
        arr << create(:managed_resource, class_name: "User", action: "read")
        arr << create(:managed_resource, class_name: "User", action: "create")
        arr << create(:managed_resource, class_name: "User", action: "update")
        arr << create(:managed_resource, class_name: "User", action: "destroy")
      end
    end

    describe ".update_all_from_managed_resources" do
      subject { Permission.update_all_from_managed_resources(managed_resources) }
      it { expect { subject }.to change { Permission.count }.from(0).to(4) }
    end

    describe ".indexed_cache" do
      before { Permission.update_all_from_managed_resources(managed_resources) }
      subject(:index) { Permission.indexed_cache }

      it { should be_a Hash }
      it { index["staff"].should be_a Array }
      it { index["staff"][0].should be_a Permission }
    end

    describe ".clear_cache" do
      before do
        Permission.update_all_from_managed_resources(managed_resources)
        Permission.indexed_cache
      end

      subject(:clear_cache) { Permission.clear_cache }

      it "should clear cache" do
        Permission.instance_variable_get(:"@_indexed_cache").should_not be_nil
        clear_cache
        Permission.instance_variable_get(:"@_indexed_cache").should be_nil
      end
    end
  end
end
