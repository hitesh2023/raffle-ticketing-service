class AddRewardItemToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :reward_item, :string
  end
end
