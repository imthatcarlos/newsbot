class CreateContexts < ActiveRecord::Migration[5.0]
  def change
    create_table :contexts do |t|
      t.integer :user_id
      t.string :state
      t.string :param
      t.timestamps
    end
  end
end
