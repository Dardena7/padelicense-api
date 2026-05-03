require "rails_helper"

RSpec.describe "me query" do
  let(:query) do
    <<~GQL
      query {
        me {
          publicId
          email
          firstName
          lastName
          role
        }
      }
    GQL
  end

  it "returns the current user when authenticated" do
    user = create(:user, email: "john@example.com", first_name: "John", last_name: "Doe")

    result = AppSchema.execute(query, context: { current_user: user })
    data = result.dig("data", "me")

    expect(data["email"]).to eq("john@example.com")
    expect(data["firstName"]).to eq("John")
    expect(data["lastName"]).to eq("Doe")
    expect(data["publicId"]).to eq(user.public_id)
    expect(data["role"]).to eq("CUSTOMER")
  end

  it "returns null when not authenticated" do
    result = AppSchema.execute(query, context: { current_user: nil })

    expect(result.dig("data", "me")).to be_nil
  end
end
