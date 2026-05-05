require "rails_helper"

RSpec.describe Addresses::Delete do
  it "deletes the address" do
    address = create(:address)

    described_class.run(address:)

    expect(Address.find_by(id: address.id)).to be_nil
  end
end
