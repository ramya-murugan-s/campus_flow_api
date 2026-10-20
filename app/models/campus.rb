class Campus < ApplicationRecord
	validates :name, presence: true

	has_many :users, dependent: :restrict_with_error
	has_many :students, dependent: :restrict_with_error
end
