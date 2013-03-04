class AddPictureToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :fb_pic, :string
  end
end
