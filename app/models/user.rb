class User < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_many :jobs, through: :properties
  has_many :properties, dependent: :destroy
  has_many :roles, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :chatroom_members, dependent: :destroy
  # has_many :reviews, through: :jobs, through: :properties
  # how do I combine more tan one trough in one has_many:  ?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
