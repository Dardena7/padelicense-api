require "rails_helper"

RSpec.describe Admin::Products::Update do
  let(:category) { create(:category) }
  let(:product) { create(:product, category:, brand: "Old", base_price_cents: 10000) }
  let(:translations) do
    [
      { locale: "en", name: "Updated", slug: "updated", description: "New desc" },
      { locale: "fr", name: "Mis à jour", slug: "mis-a-jour", description: "Nouvelle desc" },
      { locale: "nl", name: "Bijgewerkt", slug: "bijgewerkt", description: "Nieuwe desc" }
    ]
  end

  it "updates translations" do
    described_class.run(product:, translations:)

    product.reload
    I18n.with_locale(:en) { expect(product.name).to eq("Updated") }
    I18n.with_locale(:fr) { expect(product.name).to eq("Mis à jour") }
  end

  it "updates attributes" do
    new_category = create(:category)

    described_class.run(
      product:, translations:,
      category: new_category, base_price_cents: 25000, brand: "New", status: "active", featured: true
    )

    product.reload
    expect(product.category).to eq(new_category)
    expect(product.base_price_cents).to eq(25000)
    expect(product.brand).to eq("New")
    expect(product.status).to eq("active")
    expect(product.featured).to be true
  end
end
