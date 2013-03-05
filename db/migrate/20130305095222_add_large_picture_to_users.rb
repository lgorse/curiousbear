class AddLargePictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_pic_large, :string
  end
end
