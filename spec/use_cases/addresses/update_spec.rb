require "rails_helper"

RSpec.describe Addresses::Update do
  let(:address) { create(:address) }

  it "updates the address" do
    result = described_class.run(address:, attributes: { line1: "Nouveau 42" })

    expect(result.line1).to eq("Nouveau 42")
  end

  it "raises on invalid attributes" do
    expect {
      described_class.run(address:, attributes: { line1: "" })
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
