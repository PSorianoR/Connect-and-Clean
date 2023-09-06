class Property < ApplicationRecord
  belongs_to :user
  has_many :jobs, dependent: :destroy
  has_many :teams, dependent: :destroy
end
