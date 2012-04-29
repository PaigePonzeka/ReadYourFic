class CreateStoryrelations < ActiveRecord::Migration
  def change
    create_table :storyrelations do |t|
      t.integer :story_id
      t.integer :ship_id

      t.timestamps
    end
  end
end
