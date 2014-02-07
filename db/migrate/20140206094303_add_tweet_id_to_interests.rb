class AddTweetIdToInterests < ActiveRecord::Migration
  def change
    add_column :interests, :tweet_id, :string
    remove_column :interests, :interest
    add_column :interests, :like_count, :integer
  end
end
