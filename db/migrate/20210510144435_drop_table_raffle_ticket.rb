class DropTableRaffleTicket < ActiveRecord::Migration[6.1]
  def change
    drop_table :raffle_tickets
  end
end
