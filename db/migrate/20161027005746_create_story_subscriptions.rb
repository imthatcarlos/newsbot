class CreateStorySubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :story_subscriptions do |t|
      t.integer :user_id
      t.integer :source_id
      t.integer :ranking, default: 1
      t.time :scheduled_time
      t.string :scheduled_frequency
      t.timestamps
    end
  end
end
