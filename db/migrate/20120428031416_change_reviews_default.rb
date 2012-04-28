class ChangeReviewsDefault < ActiveRecord::Migration
  def up
    change_column :stories, :reviews, :integer, :default => 0
  end

end
