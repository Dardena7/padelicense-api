require "rails_helper"

RSpec.describe User do
  describe "validations" do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:role).with_values(customer: "customer", admin: "admin").backed_by_column_of_type(:string) }
  end

  describe "factory" do
    it "creates a valid user" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "creates a valid admin" do
      admin = build(:user, :admin)
      expect(admin).to be_admin
    end
  end
end
