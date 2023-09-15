class Job < ApplicationRecord
  belongs_to :property
  belongs_to :user
  has_many :job_applications, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :jobs
  has_many :messages, dependent: :destroy

  # validates :price, presence: true, numericality: { greater_than: 0 }
  # validates :description, presence: true, length: { minimum: 10 }

  def cleaner

    selected_job = self.job_applications.where(status: ["applied","accepted", "completed"]).first
    if selected_job
      job_cleaner = selected_job.user
    else
      job_cleaner = nil
    end

    return job_cleaner
  end

end
