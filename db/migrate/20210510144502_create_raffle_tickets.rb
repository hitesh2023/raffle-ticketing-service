class CreateRaffleTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :raffle_tickets do |t|
      t.integer :ticket_number
      t.references :event, null: false, foreign_key: true
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
