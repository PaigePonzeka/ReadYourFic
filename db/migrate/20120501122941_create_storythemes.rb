class CreateStorythemes < ActiveRecord::Migration
  def change
    create_table :storythemes do |t|
      t.integer :story_id
      t.integer :theme_id

      t.timestamps
    end
  end
end
