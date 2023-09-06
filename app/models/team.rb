class Team < ApplicationRecord
  belongs_to :user
  belongs_to :property

  validates :profession, presence: true
end
