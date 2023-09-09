class Message < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user
  belongs_to :job, optional: true
  has_many :job_messages
end
