require "rails_helper"

RSpec.describe "Auth::Tokens" do
  describe "POST /auth/refresh" do
    let(:user) { create(:user) }

    it "returns new access token and rotates refresh token cookie" do
      refresh_token = create(:refresh_token, user: user)

      post "/auth/refresh", as: :json,
        headers: { "Cookie" => "refresh_token=#{refresh_token.token}" }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["access_token"]).to be_present
      expect(body).not_to have_key("refresh_token")
      expect(response.cookies["refresh_token"]).to be_present
      expect(response.cookies["refresh_token"]).not_to eq(refresh_token.token)
    end

    it "destroys the old refresh token (rotation)" do
      refresh_token = create(:refresh_token, user: user)
      old_token = refresh_token.token

      post "/auth/refresh", as: :json,
        headers: { "Cookie" => "refresh_token=#{old_token}" }

      expect(RefreshToken.find_by(token: old_token)).to be_nil
    end

    it "returns 401 for an invalid refresh token" do
      post "/auth/refresh", as: :json,
        headers: { "Cookie" => "refresh_token=invalid" }

      expect(response).to have_http_status(:unauthorized)
      body = JSON.parse(response.body)
      expect(body["error"]).to eq("Invalid refresh token")
    end

    it "returns 401 for an expired refresh token" do
      refresh_token = create(:refresh_token, :expired, user: user)

      post "/auth/refresh", as: :json,
        headers: { "Cookie" => "refresh_token=#{refresh_token.token}" }

      expect(response).to have_http_status(:unauthorized)
      body = JSON.parse(response.body)
      expect(body["error"]).to eq("Refresh token expired")
    end

    it "returns 401 when no cookie is present" do
      post "/auth/refresh", as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
