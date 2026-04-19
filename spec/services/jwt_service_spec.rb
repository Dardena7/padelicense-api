require "rails_helper"

RSpec.describe JwtService do
  let(:user) { create(:user) }

  describe ".encode" do
    it "returns a JWT string" do
      token = described_class.encode(user)
      expect(token).to be_a(String)
      expect(token.split(".").length).to eq(3)
    end
  end

  describe ".decode" do
    it "returns the payload with user_id" do
      token = described_class.encode(user)
      payload = described_class.decode(token)
      expect(payload["user_id"]).to eq(user.public_id)
    end

    it "raises ExpiredToken for an expired token" do
      token = described_class.encode(user)
      travel_to 20.minutes.from_now do
        expect { described_class.decode(token) }.to raise_error(JwtService::ExpiredToken)
      end
    end

    it "raises InvalidToken for a tampered token" do
      expect { described_class.decode("invalid.token.here") }.to raise_error(JwtService::InvalidToken)
    end
  end
end
