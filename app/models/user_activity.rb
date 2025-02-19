class UserActivity < ApplicationRecord
  belongs_to :activity
  belongs_to :program
end
