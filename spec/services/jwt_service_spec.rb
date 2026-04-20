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
    it "returns the payload with user_id, iss, and aud" do
      token = described_class.encode(user)
      payload = described_class.decode(token)
      expect(payload["user_id"]).to eq(user.public_id)
      expect(payload["iss"]).to eq("padelicense-api")
      expect(payload["aud"]).to eq("padelicense-shop")
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

    it "raises InvalidToken for a token with wrong issuer" do
      payload = { user_id: user.public_id, exp: 1.hour.from_now.to_i, iss: "other-api", aud: "padelicense-shop" }
      token = JWT.encode(payload, JwtService::SECRET_KEY, JwtService::ALGORITHM)
      expect { described_class.decode(token) }.to raise_error(JwtService::InvalidToken)
    end

    it "raises InvalidToken for a token with wrong audience" do
      payload = { user_id: user.public_id, exp: 1.hour.from_now.to_i, iss: "padelicense-api", aud: "other-app" }
      token = JWT.encode(payload, JwtService::SECRET_KEY, JwtService::ALGORITHM)
      expect { described_class.decode(token) }.to raise_error(JwtService::InvalidToken)
    end
  end
end
