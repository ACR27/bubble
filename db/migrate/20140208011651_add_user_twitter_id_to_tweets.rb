class AddUserTwitterIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :user_twtter_id, :integer
  end
end
