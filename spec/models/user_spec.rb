require "rails_helper"

RSpec.describe User, type: :model do

  describe "factory" do
    it "creates a valid user" do
      user = create(:user)

      expect(user).to be_persisted
      expect(user.campus).to be_present
      expect(user.role).to eq("teacher")
    end
  end

  describe "associations" do
    it "belongs to a campus" do
      association = described_class.reflect_on_association(:campus)

      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "roles" do
    it "defaults to teacher" do
      user = described_class.new

      expect(user.role).to eq("teacher")
    end

    it "supports the admin role" do
      user = described_class.new(role: "admin")

      expect(user).to be_admin
    end
  end

  describe "validations" do
    it "requires an email" do
      campus = Campus.create!(name: "Test Campus")
      user = described_class.new(
        campus: campus,
        email: nil,
        password: "password123"
      )

      expect(user).not_to be_valid
    end

    it "rejects duplicate email addresses" do
      campus = Campus.create!(name: "Test Campus")

      User.create!(
        campus: campus,
        email: "teacher@example.com",
        password: "password123"
      )

      duplicate_user = User.new(
        campus: campus,
        email: "teacher@example.com",
        password: "password123"
      )

      expect(duplicate_user).not_to be_valid
    end

    it "rejects an unsupported role" do
      expect {
        User.new(role: "principal")
      }.to raise_error(ArgumentError)
    end
  end
end
