class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.string :event_name

      t.timestamps
    end
  end
end
