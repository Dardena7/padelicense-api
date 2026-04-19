require "rails_helper"

RSpec.describe RefreshToken do
  describe "validations" do
    subject { create(:refresh_token) }

    it { is_expected.to validate_uniqueness_of(:token) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "defaults" do
    it "generates a token automatically" do
      token = create(:refresh_token)
      expect(token.token).to be_present
      expect(token.token.length).to eq(64)
    end

    it "sets expires_at to 30 days from now" do
      freeze_time do
        token = create(:refresh_token)
        expect(token.expires_at).to eq(30.days.from_now)
      end
    end
  end

  describe "#expired?" do
    it "returns false for a valid token" do
      token = create(:refresh_token)
      expect(token).not_to be_expired
    end

    it "returns true for an expired token" do
      token = create(:refresh_token, :expired)
      expect(token).to be_expired
    end
  end
end
