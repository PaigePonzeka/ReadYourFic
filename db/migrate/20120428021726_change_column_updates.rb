class ChangeColumnUpdates < ActiveRecord::Migration
  def up
    rename_column :stories, :updates, :updated
  end

  def down
    rename_column :stories, :updated, :updates
  end
end
