class AddCompatabilityToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :compatability, :integer
  end
end
