class Admin < ApplicationRecord
    has_secure_password
    has_many :sessions, as: :resource, dependent: :destroy
    has_many :activities, dependent: :nullify
    has_many :programs, dependent: :nullify

    normalizes :email_address, with: ->(e) { e.strip.downcase }
end
