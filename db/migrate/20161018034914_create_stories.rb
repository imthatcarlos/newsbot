class CreateStories < ActiveRecord::Migration[5.0]
  def change
    create_table :stories do |t|
      t.string :title
      t.string :subtitle
      t.string :url
      t.text :summary
      t.string :image_url
      t.date :published_date
      t.string :category
      t.integer :popularity
      t.timestamps
    end
  end
end
