class CreateProtagnists < ActiveRecord::Migration
  def change
    create_table :protagnists do |t|
      t.integer :story_id
      t.integer :character_id

      t.timestamps
    end
  end
end
