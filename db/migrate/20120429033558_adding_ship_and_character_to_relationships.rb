class AddingShipAndCharacterToRelationships < ActiveRecord::Migration
  def up
    add_column :relationships, :ship_id, :integer
    add_column :relationships, :character_id, :integer
  end

  def down
  end
end
