class ProgramActivity < ApplicationRecord
  belongs_to :program
  belongs_to :activity

  enum :frequency, { daily: 0, weekly: 1, monthly: 2 }

  validates :activity_id, uniqueness: { scope: :program_id, message: "already exists for this program" }

  def frequency
    self[:frequency] || activity.frequency
  end

  def repetition
    self[:repetition] || activity.repetition
  end
end
