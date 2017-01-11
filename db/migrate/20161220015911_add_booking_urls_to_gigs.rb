class AddBookingUrlsToGigs < ActiveRecord::Migration[5.0]

  def change
    add_column :gigs, :venue_booking_url, :string
    add_column :gigs, :ticketmaster_booking_url, :string
  end
end
