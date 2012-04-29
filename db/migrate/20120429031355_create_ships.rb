class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :name

      t.timestamps
    end
  end
end
