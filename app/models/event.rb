class Event < ApplicationRecord
  has_many :user_events
  has_many :users, through: :user_events
  has_many :raffle_tickets
  accepts_nested_attributes_for :raffle_tickets, allow_destroy: true 

  validates :event_name, presence: true, uniqueness: { case_sensitive: false }
  validates :reward_item, presence: true
  validate :event_start_and_end_date

  def self.get_active_events
    where("event_start_time >= :current_time", current_time: Time.now).order("id DESC")
  end

  def registered_already?(user_id)
    users.pluck(:id).include?(user_id)
  end

  def event_start_and_end_date
    if event_start_time.present? && event_start_time < Time.now
      errors.add(:event_start_time, "can't be in the past")
    elsif event_end_time.present? && event_end_time < Time.now
      errors.add(:event_end_time, "can't be in the past")
    elsif event_start_time.present? && event_end_time.present? && event_start_time > event_end_time
      errors.add(:event_start_time, "can't be greater than event_end_time")
    end
  end
end
