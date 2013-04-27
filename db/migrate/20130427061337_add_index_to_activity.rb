class AddIndexToActivity < ActiveRecord::Migration
  def change
  	add_index :activities, :feed_id
  end
end
