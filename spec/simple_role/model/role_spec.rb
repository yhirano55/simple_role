require "rails_helper"

RSpec.describe SimpleRole::Model::Role, type: :model do
  describe "included" do
    subject(:instance) { build(:admin_user) }

    it { should define_enum_for(:role) }
    it { should delegate_method(:super_user_roles).to(:class) }
    it { should delegate_method(:guest_user_roles).to(:class) }
    it { should validate_presence_of(:role) }
  end

  describe "InstanceMethods" do
    describe "#super_user?" do
      let(:instance) { build(:admin_user, role: role) }

      subject { instance.super_user? }

      context "when role is guest" do
        let(:role) { :guest }
        it { should be_falsey }
      end

      context "when role is staff" do
        let(:role) { :staff }
        it { should be_falsey }
      end

      context "when role is admin" do
        let(:role) { :admin }
        it { should be_truthy }
      end
    end

    describe "#guest_user?" do
      let(:instance) { build(:admin_user, role: role) }

      subject { instance.guest_user? }

      context "when role is guest" do
        let(:role) { :guest }
        it { should be_truthy }
      end

      context "when role is staff" do
        let(:role) { :staff }
        it { should be_falsey }
      end

      context "when role is admin" do
        let(:role) { :admin }
        it { should be_falsey }
      end
    end
  end

  describe "ClassMethods" do
    describe ".manageable_roles" do
      let(:super_user_roles) { SimpleRole.config.super_user_roles }
      let(:guest_user_roles) { SimpleRole.config.guest_user_roles }
      let(:manageless_roles) { (super_user_roles + guest_user_roles).map(&:to_s) }
      let(:result) { AdminUser.roles.except(*manageless_roles) }
      subject { AdminUser.manageable_roles }
      it { should match_array result }
    end

    describe ".super_user_roles" do
      let(:result) { SimpleRole.config.super_user_roles.map(&:to_s) }
      subject { AdminUser.super_user_roles }
      it { should match_array result }
    end

    describe ".guest_user_roles" do
      let(:result) { SimpleRole.config.guest_user_roles.map(&:to_s) }
      subject { AdminUser.guest_user_roles }
      it { should match_array result }
    end
  end
end
