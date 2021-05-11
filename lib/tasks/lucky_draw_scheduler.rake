namespace :lucky_draw_scheduler do
  desc "Run Lucky draw scheduler to announce the winner of each event"
  task run: :environment do
    events = Event.future_events # change this
    events.each do |event|
      raffle_tickets = event.raffle_tickets
      ticket_numbers = raffle_tickets.pluck(:ticket_number)
      return if ticket_numbers.blank?

      index = rand(ticket_numbers.size)
      event.lucky_ticket_number = ticket_numbers[index]
      event.save!
    end
  end
end
