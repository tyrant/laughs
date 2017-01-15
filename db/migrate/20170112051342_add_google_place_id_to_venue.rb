class AddGooglePlaceIdToVenue < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :google_place_id, :string
  end
end
