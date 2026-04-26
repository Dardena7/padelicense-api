require "rails_helper"

RSpec.describe CategoryPolicy do
  let(:admin) { create(:user, :admin) }
  let(:customer) { create(:user) }
  let(:category) { create(:category) }

  describe "#show?" do
    it "allows anyone" do
      expect(described_class.new(nil, category).show?).to be_truthy
      expect(described_class.new(customer, category).show?).to be_truthy
    end
  end

  describe "#create?" do
    it "denies non-admins" do
      expect(described_class.new(nil, category).create?).to be_falsey
      expect(described_class.new(customer, category).create?).to be_falsey
    end

    it "allows admins" do
      expect(described_class.new(admin, category).create?).to be_truthy
    end
  end

  describe "#destroy?" do
    it "denies non-admins" do
      expect(described_class.new(customer, category).destroy?).to be_falsey
    end

    it "allows admins" do
      expect(described_class.new(admin, category).destroy?).to be_truthy
    end
  end
end
