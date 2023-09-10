class Chatroom < ApplicationRecord
  has_many :chatroom_members
  has_many :messages
end
