require "rails_helper"

RSpec.describe AppSchema do
  it "has a default page size of 20" do
    expect(described_class.default_page_size).to eq(20)
  end

  it "has a max page size of 100" do
    expect(described_class.default_max_page_size).to eq(100)
  end
end
