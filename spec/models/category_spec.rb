require "rails_helper"

RSpec.describe Category do
  describe "validations" do
    subject { create(:category) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_uniqueness_of(:slug) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:parent).class_name("Category").optional }
    it { is_expected.to have_many(:subcategories).class_name("Category").dependent(:destroy) }
  end

  describe "self-referential hierarchy" do
    it "can have subcategories" do
      parent = create(:category, name: "Rackets", slug: "rackets")
      child = create(:category, name: "Control", slug: "control", parent: parent)

      expect(parent.subcategories).to include(child)
      expect(child.parent).to eq(parent)
    end

    it "destroys subcategories when parent is destroyed" do
      parent = create(:category, slug: "parent")
      create(:category, slug: "child", parent: parent)

      expect { parent.destroy }.to change(Category, :count).by(-2)
    end
  end
end
