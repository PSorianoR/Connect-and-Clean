class Job < ApplicationRecord
  belongs_to :property
  belongs_to :user
  has_many :job_applications, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :jobs
  has_many :messages, dependent: :destroy

  # validates :price, presence: true, numericality: { greater_than: 0 }
  # validates :description, presence: true, length: { minimum: 10 }
end
