require "rails_helper"

RSpec.describe "updateProfile mutation" do
  let(:mutation) do
    <<~GQL
      mutation UpdateProfile($input: UpdateProfileInput!) {
        updateProfile(input: $input) {
          user {
            publicId
            firstName
            lastName
            email
            phone
          }
        }
      }
    GQL
  end

  it "updates the user's profile" do
    user = create(:user, first_name: "John", last_name: "Doe", email: "john@example.com")

    result = AppSchema.execute(mutation, context: { current_user: user }, variables: {
      input: { firstName: "Jane", lastName: "Smith", phone: "+32 470 123456" }
    })
    data = result.dig("data", "updateProfile", "user")

    expect(data["firstName"]).to eq("Jane")
    expect(data["lastName"]).to eq("Smith")
    expect(data["phone"]).to eq("+32 470 123456")
    expect(data["email"]).to eq("john@example.com")
  end

  it "updates only provided fields" do
    user = create(:user, first_name: "John")

    result = AppSchema.execute(mutation, context: { current_user: user }, variables: {
      input: { phone: "+32 470 000000" }
    })
    data = result.dig("data", "updateProfile", "user")

    expect(data["firstName"]).to eq("John")
    expect(data["phone"]).to eq("+32 470 000000")
  end

  it "only updates the current user, not another user" do
    user = create(:user, first_name: "John")
    other = create(:user, first_name: "Other")

    AppSchema.execute(mutation, context: { current_user: user }, variables: {
      input: { firstName: "Changed" }
    })

    expect(user.reload.first_name).to eq("Changed")
    expect(other.reload.first_name).to eq("Other")
  end

  it "rejects unauthenticated requests" do
    result = AppSchema.execute(mutation, context: { current_user: nil }, variables: {
      input: { firstName: "Hacker" }
    })

    expect(result.dig("data", "updateProfile")).to be_nil
  end
end
