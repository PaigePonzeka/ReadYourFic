class CreateStoryShips < ActiveRecord::Migration
  def change
    create_table :story_ships do |t|
      t.integer :story_id
      t.integer :ship_id

      t.timestamps
    end
  end
end
