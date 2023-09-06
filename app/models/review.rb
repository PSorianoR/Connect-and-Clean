class Review < ApplicationRecord
  belongs_to :user
  belongs_to :job

  # validates :rating, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 5 }
  # validates :description, presence: true, length: { minimum: 10 }
end
