require "rails_helper"

RSpec.describe Cart do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:items).class_name("CartItem").dependent(:destroy) }
  end
end
