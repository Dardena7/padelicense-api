require "rails_helper"

RSpec.describe "Auth::Tokens" do
  describe "POST /auth/refresh" do
    let(:user) { create(:user) }

    it "returns new tokens for a valid refresh token" do
      refresh_token = create(:refresh_token, user: user)

      post "/auth/refresh", params: { refresh_token: refresh_token.token }, as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["access_token"]).to be_present
      expect(body["refresh_token"]).to be_present
      expect(body["refresh_token"]).not_to eq(refresh_token.token)
    end

    it "destroys the old refresh token (rotation)" do
      refresh_token = create(:refresh_token, user: user)
      old_token = refresh_token.token

      post "/auth/refresh", params: { refresh_token: old_token }, as: :json

      expect(RefreshToken.find_by(token: old_token)).to be_nil
    end

    it "returns 401 for an invalid refresh token" do
      post "/auth/refresh", params: { refresh_token: "invalid" }, as: :json

      expect(response).to have_http_status(:unauthorized)
      body = JSON.parse(response.body)
      expect(body["error"]).to eq("Invalid refresh token")
    end

    it "returns 401 for an expired refresh token" do
      refresh_token = create(:refresh_token, :expired, user: user)

      post "/auth/refresh", params: { refresh_token: refresh_token.token }, as: :json

      expect(response).to have_http_status(:unauthorized)
      body = JSON.parse(response.body)
      expect(body["error"]).to eq("Refresh token expired")
    end

    it "cleans up expired refresh tokens" do
      refresh_token = create(:refresh_token, :expired, user: user)
      token_id = refresh_token.id

      post "/auth/refresh", params: { refresh_token: refresh_token.token }, as: :json

      expect(RefreshToken.find_by(id: token_id)).to be_nil
    end
  end
end
