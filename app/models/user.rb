class User < ApplicationRecord
  has_secure_password
  has_one :raffle_ticket
  has_many :user_events
  has_many :events, through: :user_events
end
