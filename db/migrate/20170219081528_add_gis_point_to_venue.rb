class AddGisPointToVenue < ActiveRecord::Migration[5.0]

  def up
    add_column :venues, :location, :st_point, geographic: true

    Venue.find_each do |venue|
      venue.set_location(latitude: venue.latitude, longitude: venue.longitude)
      venue.save
    end

    remove_column :venues, :latitude
    remove_column :venues, :longitude
  end

  def down
    add_column :venues, :latitude, :float
    add_column :venues, :longitude, :float

    Venue.find_each do |venue|
      venue.latitude = venue.location.y
      venue.longitude = veue.location.x
      venue.save
    end

    remove_column :venues, :location
  end

end
