class ProgramActivity < ApplicationRecord
  belongs_to :program
  belongs_to :activity

  enum :frequency, { daily: 0, weekly: 1 }

  validates :activity_id, uniqueness: { scope: :program_id, message: "already exists for this program" }
  validate :repetition_within_frequency_range

  def frequency
    self[:frequency] || activity&.frequency
  end

  def repetition
    self[:repetition] || activity&.repetition
  end

  def weekday_occurrences?(weekday)
    case repetition
    when 3
      [2, 4, 6].include?(weekday)
    when 2
      [3, 5].include?(weekday)
    else
      [4].include?(weekday)
    end
  end

  private 

  def repetition_within_frequency_range
    return unless repetition && frequency

    case frequency
    when "daily"
      errors.add(:repetition, "must be less than 10 for daily frequency") if repetition > 10
    when "weekly"
      errors.add(:repetition, "must be 3 or less for weekly frequency") if repetition > 3
    end
  end
end
