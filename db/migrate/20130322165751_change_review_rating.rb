class ChangeReviewRating < ActiveRecord::Migration
  def change
  	change_column :reviews, :rating, :integer
  end
end
