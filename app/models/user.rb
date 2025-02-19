class User < ApplicationRecord
  has_secure_password
  has_many :sessions, as: :resource, dependent: :destroy
  has_many :programs, dependent: :nullify

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def active_program?
    current_program.present?
  end

  def current_program
    programs.where("start_date <= ? AND end_date >= ?", Date.today, Date.today)&.first
  end
end
