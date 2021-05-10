class Event < ApplicationRecord
  has_one :raffle_ticket
  has_many :user_events
  has_many :users, through: :user_events
end
