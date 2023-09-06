class Team < ApplicationRecord
  belongs_to :user
  belongs_to :property
end
