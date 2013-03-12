class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :restaurant_id, :null => false
      t.integer :user_id, :null => false
      t.decimal :rating, :precision =>2, :scale => 1
      t.text :text
      t.string :keywords

      t.timestamps
    end
    add_index :reviews, :restaurant_id
  add_index :reviews, :user_id
  end
end
