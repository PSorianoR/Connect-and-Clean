class User < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_many :properties, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :chatroom_members, dependent: :destroy
  has_many :messages, dependent: :destroy
  # has_many :reviews, through: :jobs, through: :properties
  # how do I combine more tan one trough in one has_many:  ?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # validates :name, :birth_date, :address, presence:true
  has_one_attached :photo


  def average_rating
    reviews.average(:rating).to_f
  end

  def number_of_completed_jobs
    jobs.where(status: "Completed").count
  end

  def cleaner_tier
    if number_of_completed_jobs > 10
      if avarage_rating > 4.5
        "#3083dc;"
      elsif avarage_rating > 4
        "#ffea00;"
      elsif avarage_rating > 3.5
        "#8e9aaf;"
      else
        "#ef8354;"
      end
    else
      "#ffffff;"
    end
  end
end
