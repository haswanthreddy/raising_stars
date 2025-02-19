class Activity < ApplicationRecord
  belongs_to :admin, optional: true

  enum :frequency, {
      daily: 0,
      weekly: 1
    }

    enum :category, {
      exercise: 0,
      stimulation: 1,
      cognitive: 3,
      visual: 4,
      logical: 5,
      speaking: 6,
      knowledge: 7,
      memory: 8,
      entertainment: 9,
      play: 11
    }

  validates :repetition, numericality: { greater_than: 0 }
  validate :repetition_within_frequency_range
  validates :name, uniqueness: { case_sensitive: false, message: "name has already been taken" }

  def created_by
    admin
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
