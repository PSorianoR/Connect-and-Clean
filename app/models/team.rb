class Team < ApplicationRecord
  belongs_to :user
  belongs_to :property

  validates :type, presence: true
end
