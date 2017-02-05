class AddIndicesToVenues < ActiveRecord::Migration[5.0]
  def change
    add_index :venues, :latitude
    add_index :venues, :longitude
  end
end
