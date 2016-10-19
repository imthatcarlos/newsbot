class AddPreferencesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :story_preference1, :string
    add_column :users, :story_preference2, :string
    add_column :users, :story_preference3, :string
  end
end
