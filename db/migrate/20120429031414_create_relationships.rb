class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|

      t.timestamps
    end
  end
end
