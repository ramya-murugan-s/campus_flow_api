require "rails_helper"

RSpec.describe Student, type: :model do
  describe "associations" do
    it "belongs to a campus" do
      association = described_class.reflect_on_association(:campus)

      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      student = build(:student)

      expect(student).to be_valid
    end

    it "requires a name" do
      student = build(:student, name: nil)

      expect(student).not_to be_valid
    end

    it "requires an email" do
      student = build(:student, email: nil)

      expect(student).not_to be_valid
    end

    it "requires a date of birth" do
      student = build(:student, date_of_birth: nil)

      expect(student).not_to be_valid
    end
  end
end