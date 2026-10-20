class Student < ApplicationRecord
  belongs_to :campus

  validates :name, presence: true
  validates :email, presence: true
  validates :date_of_birth, presence: true
end
