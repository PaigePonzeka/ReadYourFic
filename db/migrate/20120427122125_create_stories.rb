class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :title
      t.integer :ff_id
      t.integer :author_id
      t.text :summary
      t.string :rating
      t.string :language
      t.text :theme
      t.integer :chapters
      t.integer :words
      t.integer :reviews
      t.boolean :complete
      t.text :characters
      t.date :published
      t.date :updates

      t.timestamps
    end
  end
end
