class ChangeTwitterIdToString < ActiveRecord::Migration
  def change
    remove_column :interests, :user_id
    add_column :interests, :user_id, :string
    remove_column :matches, :user1
    remove_column :matches, :user2
    add_column :matches, :user1, :string
    add_column :matches, :use2, :string
    remove_column :tweets, :twitter_id
    add_column :tweets, :twitter_id, :string 
    remove_column :tweets, :user_twitter_id
    add_column :tweets, :user_twitter_id, :string 
  end
end
