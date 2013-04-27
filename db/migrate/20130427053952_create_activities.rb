class CreateActivities < ActiveRecord::Migration
	def change
		create_table :activities do |t|
			t.integer :feed_id, :null => false
			t.integer :user_id, :null => false
			t.integer :activity, :null => false
			t.integer :target_id
			t.float :edgerank
			
			t.timestamps
		end
	end
end
