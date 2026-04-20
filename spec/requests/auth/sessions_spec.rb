require "rails_helper"

RSpec.describe "Auth::Sessions" do
  describe "POST /auth/login" do
    let!(:user) { create(:user, email: "john@example.com", password: "password123") }

    it "returns tokens for valid credentials" do
      post "/auth/login", params: { email: "john@example.com", password: "password123" }, as: :json

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["user"]["email"]).to eq("john@example.com")
      expect(body["access_token"]).to be_present
      expect(body["refresh_token"]).to be_present
    end

    it "returns 401 for wrong password" do
      post "/auth/login", params: { email: "john@example.com", password: "wrong" }, as: :json

      expect(response).to have_http_status(:unauthorized)
      body = JSON.parse(response.body)
      expect(body["error"]).to eq("Invalid email or password")
    end

    it "returns 401 for non-existent email" do
      post "/auth/login", params: { email: "nobody@example.com", password: "password123" }, as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /auth/logout" do
    let(:user) { create(:user) }

    it "destroys all refresh tokens" do
      token = JwtService.encode(user)
      create_list(:refresh_token, 3, user: user)

      delete "/auth/logout", headers: { "Authorization" => "Bearer #{token}" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(user.refresh_tokens.count).to eq(0)
    end

    it "returns 401 without token" do
      delete "/auth/logout", as: :json

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
