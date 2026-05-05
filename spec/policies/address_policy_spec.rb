require "rails_helper"

RSpec.describe AddressPolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "#show?" do
    it "allows user to see their own address" do
      address = create(:address, user:)
      expect(described_class.new(user, address).show?).to be_truthy
    end

    it "denies user from seeing another user's address" do
      address = create(:address, user: other_user)
      expect(described_class.new(user, address).show?).to be_falsey
    end

    it "allows admin to see any address" do
      address = create(:address, user:)
      expect(described_class.new(admin, address).show?).to be_truthy
    end

    it "denies unauthenticated access" do
      address = create(:address, user:)
      expect(described_class.new(nil, address).show?).to be_falsey
    end
  end
end
