require "rails_helper"

RSpec.describe "me query — addresses" do
  let(:query) do
    <<~GQL
      query {
        me {
          addresses {
            id
            label
            line1
            city
            postalCode
            countryIso
          }
        }
      }
    GQL
  end

  it "returns the user's addresses" do
    user = create(:user)
    create(:address, user:, label: "Maison", line1: "Rue de la Loi 1", city: "Bruxelles")

    result = AppSchema.execute(query, context: { current_user: user })
    data = result.dig("data", "me", "addresses")

    expect(data.length).to eq(1)
    expect(data.first["label"]).to eq("Maison")
    expect(data.first["line1"]).to eq("Rue de la Loi 1")
    expect(data.first["city"]).to eq("Bruxelles")
  end

  it "returns empty array when user has no addresses" do
    user = create(:user)

    result = AppSchema.execute(query, context: { current_user: user })
    data = result.dig("data", "me", "addresses")

    expect(data).to eq([])
  end
end
