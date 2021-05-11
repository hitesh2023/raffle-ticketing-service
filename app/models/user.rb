class User < ApplicationRecord
  has_secure_password
  has_one :raffle_ticket
  has_many :user_events
  has_many :events, through: :user_events

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { case_sensitive: false }, on: :create
end
