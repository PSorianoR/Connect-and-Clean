class Property < ApplicationRecord
  belongs_to :user
  has_many :jobs, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :cleaners, through: :teams

  validates :title, presence: true
  validates :address, presence: true
  validates :description, presence: true, length: { minimum: 10 }
  validates :default_job_price, presence: true, numericality: { greater_than: 0 }
  validates :default_cleaning_from, presence: true
  validates :default_cleaning_until, presence: true
end
