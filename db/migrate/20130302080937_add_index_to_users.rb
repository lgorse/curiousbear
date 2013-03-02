class AddIndexToUsers < ActiveRecord::Migration
  def change
  end
  add_index :users, :fb_id
end
