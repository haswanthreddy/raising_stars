class ProgramActivity < ApplicationRecord
  belongs_to :program
  belongs_to :activity

  enum :frequency, { daily: 0, weekly: 1, monthly: 2 }

  validates :activity_id, uniqueness: { scope: :program_id, message: "already exists for this program" }
  validate :repetition_within_frequency_range

  def frequency
    self[:frequency] || activity&.frequency
  end

  def repetition
    self[:repetition] || activity&.repetition
  end

  private 

  def repetition_within_frequency_range
    return unless repetition && frequency

    case frequency
    when 'daily'
      errors.add(:repetition, 'must be less than 10 for daily frequency') if repetition > 10
    when 'weekly'
      errors.add(:repetition, 'must be less than 7 for weekly frequency') if repetition >= 7
    when 'monthly'
      errors.add(:repetition, 'must be less than 30 for monthly frequency') if repetition >= 30
    end
  end
end
