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
end
