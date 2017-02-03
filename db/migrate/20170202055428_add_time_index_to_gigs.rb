class AddTimeIndexToGigs < ActiveRecord::Migration[5.0]
  def change
    add_index :gigs, :time
  end
end
