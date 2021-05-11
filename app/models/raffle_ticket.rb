class RaffleTicket < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validates :ticket_number, presence: true
  validate :ticket_number, :ticket_number_uniqueness

  def ticket_number_uniqueness
    records = self.event.raffle_tickets.select { |ticket| ticket.ticket_number == self.ticket_number }.size
    if records > 1
      errors.add(:raffle_tickets, "ticket number should be unique")
    end
  end

  def self.non_booked_tickets
    where("user_id IS NULL")
  end
end
