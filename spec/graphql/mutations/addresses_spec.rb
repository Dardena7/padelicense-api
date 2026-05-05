require "rails_helper"

RSpec.describe "address mutations" do
  describe "createAddress" do
    let(:mutation) do
      <<~GQL
        mutation CreateAddress($input: AddressInput!) {
          createAddress(input: { input: $input }) {
            address {
              id
              label
              line1
              line2
              city
              postalCode
              countryIso
            }
          }
        }
      GQL
    end

    it "creates an address for the authenticated user" do
      user = create(:user)

      result = AppSchema.execute(mutation, context: { current_user: user }, variables: {
        input: { label: "Maison", line1: "Rue de la Loi 1", city: "Bruxelles", postalCode: "1000", countryIso: "BE" }
      })
      data = result.dig("data", "createAddress", "address")

      expect(data["label"]).to eq("Maison")
      expect(data["line1"]).to eq("Rue de la Loi 1")
      expect(data["city"]).to eq("Bruxelles")
      expect(data["postalCode"]).to eq("1000")
      expect(data["countryIso"]).to eq("BE")
      expect(user.addresses.count).to eq(1)
    end

    it "rejects unauthenticated requests" do
      result = AppSchema.execute(mutation, context: { current_user: nil }, variables: {
        input: { line1: "Rue Test", city: "Test", postalCode: "1000", countryIso: "BE" }
      })

      expect(result.dig("data", "createAddress")).to be_nil
    end
  end

  describe "updateAddress" do
    let(:mutation) do
      <<~GQL
        mutation UpdateAddress($addressId: ID!, $input: AddressInput!) {
          updateAddress(input: { addressId: $addressId, input: $input }) {
            address {
              line1
              city
            }
          }
        }
      GQL
    end

    it "updates an existing address" do
      user = create(:user)
      address = create(:address, user:, line1: "Old Street")

      result = AppSchema.execute(mutation, context: { current_user: user }, variables: {
        addressId: AppSchema.id_from_object(address, Types::AddressType, {}),
        input: { line1: "New Street 42", city: address.city, postalCode: address.postal_code, countryIso: address.country_iso }
      })
      data = result.dig("data", "updateAddress", "address")

      expect(data["line1"]).to eq("New Street 42")
    end
  end

  describe "deleteAddress" do
    let(:mutation) do
      <<~GQL
        mutation DeleteAddress($addressId: ID!) {
          deleteAddress(input: { addressId: $addressId }) {
            address {
              id
            }
          }
        }
      GQL
    end

    it "deletes the address" do
      user = create(:user)
      address = create(:address, user:)

      AppSchema.execute(mutation, context: { current_user: user }, variables: {
        addressId: AppSchema.id_from_object(address, Types::AddressType, {})
      })

      expect(Address.find_by(id: address.id)).to be_nil
    end
  end
end
