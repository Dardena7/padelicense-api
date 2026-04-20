require "rails_helper"

RSpec.describe "Auth::Registrations" do
  describe "POST /auth/signup" do
    let(:valid_params) do
      {
        user: {
          email: "john@example.com",
          password: "password123",
          password_confirmation: "password123",
          first_name: "John",
          last_name: "Doe"
        }
      }
    end

    it "creates a user and returns tokens" do
      post "/auth/signup", params: valid_params, as: :json

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["user"]["email"]).to eq("john@example.com")
      expect(body["user"]["first_name"]).to eq("John")
      expect(body["access_token"]).to be_present
      expect(body["refresh_token"]).to be_present
    end

    it "does not expose internal ids" do
      post "/auth/signup", params: valid_params, as: :json

      body = JSON.parse(response.body)
      expect(body["user"]).not_to have_key("id")
      expect(body["user"]).not_to have_key("encrypted_password")
      expect(body["user"]["public_id"]).to be_present
    end

    it "returns errors for invalid params" do
      post "/auth/signup", params: { user: { email: "" } }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      body = JSON.parse(response.body)
      expect(body["errors"]).to be_present
    end

    it "returns errors for duplicate email" do
      create(:user, email: "john@example.com")
      post "/auth/signup", params: valid_params, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      body = JSON.parse(response.body)
      expect(body["errors"]).to include("Email has already been taken")
    end
  end
end
