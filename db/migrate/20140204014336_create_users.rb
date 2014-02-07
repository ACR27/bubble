class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :twitter_handle
      t.integer :gender

      t.timestamps
    end
  end
end
