class JobChat < ApplicationRecord
  belongs_to :job
  belongs_to :chatroom
end
