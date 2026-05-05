require "rails_helper"

RSpec.describe OrderPolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "#show?" do
    it "allows user to see their own order" do
      order = create(:order, user:)
      expect(described_class.new(user, order).show?).to be_truthy
    end

    it "denies user from seeing another user's order" do
      order = create(:order, user: other_user)
      expect(described_class.new(user, order).show?).to be_falsey
    end

    it "allows admin to see any order" do
      order = create(:order, user:)
      expect(described_class.new(admin, order).show?).to be_truthy
    end

    it "denies unauthenticated access" do
      order = create(:order, user:)
      expect(described_class.new(nil, order).show?).to be_falsey
    end
  end
end
