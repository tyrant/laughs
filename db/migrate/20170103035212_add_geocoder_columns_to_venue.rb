class AddGeocoderColumnsToVenue < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :latitude, :float
    add_column :venues, :longitude, :float
    add_column :venues, :readable_address, :string
  end
end
