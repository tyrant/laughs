class Gig < ApplicationRecord

  has_and_belongs_to_many :comedians
  belongs_to :venue
  

  def as_json(params={})
    {
      time:                     self.time,
      venue_booking_url:        self.venue_booking_url,
      ticketmaster_booking_url: self.ticketmaster_booking_url,
      comedians:                self.comedians
    }
  end

end
