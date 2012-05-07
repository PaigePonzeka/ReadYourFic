class CreateStoryships < ActiveRecord::Migration
  def change
    create_table :storyships do |t|
      t.integer :story_id
      t.integer :ship_id

      t.timestamps
    end
  end
end
