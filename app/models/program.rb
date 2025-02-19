class Program < ApplicationRecord
  belongs_to :user
  belongs_to :admin
  has_many :program_activities, dependent: :destroy

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :date_overlap_validation
  validate :start_date_before_end_date

  def deleted?
    deleted_at.present?
  end

  private

  def start_date_before_end_date
    if start_date.present? && end_date.present? && start_date >= end_date
      errors.add(:end_date, "must be after start date")
    end
  end

  def date_overlap_validation
    return if start_date.blank? || end_date.blank? || user_id.blank?

    errors.add(:base, 'Program dates overlap with an existing record') if overlapping_records.present?
  end

  def overlapping_records
    self.class.where(user_id: user_id)
    .where.not(id: id)
    .where('(start_date < :end_date AND end_date > :start_date)', 
           start_date: start_date, end_date: end_date)
  end
end
