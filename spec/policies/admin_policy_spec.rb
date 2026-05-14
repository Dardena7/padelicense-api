require "rails_helper"

RSpec.describe AdminPolicy do
  describe "#access?" do
    it "allows admin" do
      admin = create(:user, :admin)
      expect(described_class.new(admin, nil).access?).to be true
    end

    it "denies customer" do
      customer = create(:user)
      expect(described_class.new(customer, nil).access?).to be_falsey
    end

    it "denies unauthenticated" do
      expect(described_class.new(nil, nil).access?).to be_falsey
    end
  end
end
