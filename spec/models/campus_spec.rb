require "rails_helper"

RSpec.describe Campus, type: :model do
  describe "validations" do
    it "is valid with a name" do
      campus = Campus.new(name: "Tirunelveli Campus")

      expect(campus).to be_valid
    end

    it "is invalid without a name" do
      campus = Campus.new(name: nil)

      expect(campus).not_to be_valid
    end
  end
end