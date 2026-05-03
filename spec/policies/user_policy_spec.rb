require "rails_helper"

RSpec.describe UserPolicy do
  let(:customer) { create(:user) }
  let(:other_customer) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "#show?" do
    it "allows user to see their own profile" do
      expect(described_class.new(customer, customer).show?).to be_truthy
    end

    it "denies user from seeing another user's profile" do
      expect(described_class.new(customer, other_customer).show?).to be_falsey
    end

    it "allows admin to see any user's profile" do
      expect(described_class.new(admin, customer).show?).to be_truthy
    end

    it "denies unauthenticated access" do
      expect(described_class.new(nil, customer).show?).to be_falsey
    end
  end

  describe "#update?" do
    it "allows user to update their own profile" do
      expect(described_class.new(customer, customer).update?).to be_truthy
    end

    it "denies user from updating another user's profile" do
      expect(described_class.new(customer, other_customer).update?).to be_falsey
    end

    it "allows admin to update any user's profile" do
      expect(described_class.new(admin, customer).update?).to be_truthy
    end
  end
end
