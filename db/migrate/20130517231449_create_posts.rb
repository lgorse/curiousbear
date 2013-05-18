class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id, :null => false
      t.text :post_text
      t.text :recommendations

      t.timestamps
    end
     add_index :posts, :user_id
  end
end
