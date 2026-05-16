require "rails_helper"

RSpec.describe Admin::Categories::Create do
  let(:translations) do
    [
      { locale: "en", name: "Rackets", slug: "rackets", description: "All rackets" },
      { locale: "fr", name: "Raquettes", slug: "raquettes", description: "Toutes les raquettes" },
      { locale: "nl", name: "Rackets", slug: "rackets-nl", description: "Alle rackets" }
    ]
  end

  it "creates a category with translations" do
    category = described_class.run(translations:)

    expect(category).to be_persisted

    I18n.with_locale(:en) { expect(category.name).to eq("Rackets") }
    I18n.with_locale(:fr) { expect(category.name).to eq("Raquettes") }
    I18n.with_locale(:nl) { expect(category.name).to eq("Rackets") }
  end

  it "sets parent and position" do
    parent = create(:category)

    category = described_class.run(translations:, parent:, position: 2)

    expect(category.parent).to eq(parent)
    expect(category.position).to eq(2)
  end

  it "allows 3 levels deep" do
    root = create(:category)
    child = create(:category, parent: root)

    category = described_class.run(translations:, parent: child)

    expect(category).to be_persisted
    expect(category.parent).to eq(child)
  end

  it "rejects 4th level" do
    root = create(:category)
    child = create(:category, parent: root)
    grandchild = create(:category, parent: child)

    expect {
      described_class.run(translations:, parent: grandchild)
    }.to raise_error(described_class::TooDeep, /Maximum category depth is 3/)
  end
end
