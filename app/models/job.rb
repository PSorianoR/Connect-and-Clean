class Job < ApplicationRecord
  belongs_to :property
  belongs_to :user
  has_many :job_applications, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :job_chats, dependent: :destroy
end
