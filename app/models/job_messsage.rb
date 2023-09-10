class JobMessage < ApplicationRecord
  belongs_to :job
  belongs_to :message
end
