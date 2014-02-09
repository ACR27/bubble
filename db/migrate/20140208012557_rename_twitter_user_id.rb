class RenameTwitterUserId < ActiveRecord::Migration
  def change
    remove_column :tweets, :user_twtter_id
    add_column :tweets, :user_twitter_id, :integer
  end
end
