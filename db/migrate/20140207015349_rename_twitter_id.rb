class RenameTwitterId < ActiveRecord::Migration
  def change
    remove_column :tweets, :tweet_id
    add_column :tweets, :twitter_id, :integer
  end
end
