require "rails_helper"

RSpec.describe Admin::Products::Create do
  let(:category) { create(:category) }
  let(:translations) do
    [
      { locale: "en", name: "Test Racket", slug: "test-racket", description: "A test racket" },
      { locale: "fr", name: "Raquette Test", slug: "raquette-test", description: "Une raquette test" },
      { locale: "nl", name: "Test Racket NL", slug: "test-racket-nl", description: "Een test racket" }
    ]
  end

  it "creates a product with translations" do
    product = described_class.run(
      attributes: { translations:, base_price_cents: 19990, category: }
    )

    expect(product).to be_persisted
    expect(product.base_price_cents).to eq(19990)
    expect(product.status).to eq("draft")

    I18n.with_locale(:en) { expect(product.name).to eq("Test Racket") }
    I18n.with_locale(:fr) { expect(product.name).to eq("Raquette Test") }
  end

  it "sets all attributes" do
    product = described_class.run(
      attributes: {
        translations:, base_price_cents: 29990, category:,
        brand: "Head", status: "active", featured: true
      }
    )

    expect(product.brand).to eq("Head")
    expect(product.status).to eq("active")
    expect(product.featured).to be true
    expect(product.category).to eq(category)
  end
end
