class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.string :first_name
      t.date :birthday, :null => false
      t.string :gender
      t.string :e_mail
      t.integer :fb_id, :limit => 8, :null => false

      t.timestamps
    end
  end
end
