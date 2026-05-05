require "rails_helper"

RSpec.describe Addresses::Create do
  let(:user) { create(:user) }

  it "creates an address for the user" do
    address = described_class.run(
      user:,
      attributes: { line1: "Rue de la Loi 1", city: "Bruxelles", postal_code: "1000", country_iso: "BE" }
    )

    expect(address).to be_persisted
    expect(address.user).to eq(user)
    expect(address.line1).to eq("Rue de la Loi 1")
    expect(address.city).to eq("Bruxelles")
  end

  it "creates an address with optional fields" do
    address = described_class.run(
      user:,
      attributes: { label: "Bureau", line1: "Av Louise 5", line2: "Étage 3", city: "Bruxelles", postal_code: "1050", country_iso: "BE" }
    )

    expect(address.label).to eq("Bureau")
    expect(address.line2).to eq("Étage 3")
  end

  it "raises on invalid attributes" do
    expect {
      described_class.run(user:, attributes: { line1: "", city: "", postal_code: "", country_iso: "" })
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
