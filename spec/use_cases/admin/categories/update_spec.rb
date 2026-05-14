require "rails_helper"

RSpec.describe Admin::Categories::Update do
  let(:category) { create(:category) }
  let(:translations) do
    [
      { locale: "en", name: "Updated", slug: "updated", description: "New desc" },
      { locale: "fr", name: "Mis à jour", slug: "mis-a-jour", description: "Nouvelle desc" },
      { locale: "nl", name: "Bijgewerkt", slug: "bijgewerkt", description: "Nieuwe desc" }
    ]
  end

  it "updates translations" do
    described_class.run(category:, translations:)

    category.reload
    I18n.with_locale(:en) { expect(category.name).to eq("Updated") }
    I18n.with_locale(:fr) { expect(category.name).to eq("Mis à jour") }
  end

  it "updates parent and position" do
    new_parent = create(:category)

    described_class.run(category:, translations:, parent: new_parent, position: 5)

    category.reload
    expect(category.parent).to eq(new_parent)
    expect(category.position).to eq(5)
  end
end
