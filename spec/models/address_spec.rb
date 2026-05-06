require "rails_helper"

RSpec.describe Address do
  describe "validations" do
    it { is_expected.to validate_presence_of(:line1) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:postal_code) }
    it { is_expected.to validate_presence_of(:country_iso) }
    it { is_expected.to validate_length_of(:country_iso).is_equal_to(2) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "default address" do
    let(:user) { create(:user) }

    it "sets the first address as default" do
      address = create(:address, user:)
      expect(address.default).to be true
    end

    it "does not set subsequent addresses as default" do
      create(:address, user:)
      second = create(:address, user:)
      expect(second.default).to be false
    end

    it "unsets other defaults when setting a new default" do
      first = create(:address, user:, default: true)
      second = create(:address, user:)

      second.update!(default: true)

      expect(first.reload.default).to be false
      expect(second.reload.default).to be true
    end
  end
end
