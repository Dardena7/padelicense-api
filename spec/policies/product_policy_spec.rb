require "rails_helper"

RSpec.describe ProductPolicy do
  let(:admin) { create(:user, :admin) }
  let(:customer) { create(:user) }
  let(:active_product) { create(:product, status: "active") }
  let(:draft_product) { create(:product, :draft) }

  describe "#show?" do
    it "allows anyone to see active products" do
      expect(described_class.new(nil, active_product).show?).to be_truthy
      expect(described_class.new(customer, active_product).show?).to be_truthy
    end

    it "hides draft products from non-admins" do
      expect(described_class.new(nil, draft_product).show?).to be_falsey
      expect(described_class.new(customer, draft_product).show?).to be_falsey
    end

    it "allows admins to see draft products" do
      expect(described_class.new(admin, draft_product).show?).to be_truthy
    end
  end

  describe "#create?" do
    it "denies non-admins" do
      expect(described_class.new(nil, active_product).create?).to be_falsey
      expect(described_class.new(customer, active_product).create?).to be_falsey
    end

    it "allows admins" do
      expect(described_class.new(admin, active_product).create?).to be_truthy
    end
  end

  describe "Scope" do
    let!(:active) { create(:product, status: "active") }
    let!(:draft) { create(:product, :draft) }

    it "returns only active products for visitors" do
      scope = described_class::Scope.new(nil, Product).resolve
      expect(scope).to include(active)
      expect(scope).not_to include(draft)
    end

    it "returns all products for admins" do
      scope = described_class::Scope.new(admin, Product).resolve
      expect(scope).to include(active, draft)
    end
  end
end
