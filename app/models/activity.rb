class Activity < ApplicationRecord
  belongs_to :admin, optional: true

  enum :frequency, {
      daily: 0,
      weekly: 1,
      monthly: 2,
      daily: 0,
      weekly: 1,
      monthly: 2
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

  validates :name, uniqueness: { case_sensitive: false, message: "name has already been taken" }

  def created_by
    admin
  end
end
