class AddColumnToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :lucky_ticket_number, :integer
  end
end
