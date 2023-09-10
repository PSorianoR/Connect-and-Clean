class Message < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user
  belongs_to :job, optional: true
  has_many :job_messages


  def sender?(a_user)
    user.id == a_user.id
  end

end
