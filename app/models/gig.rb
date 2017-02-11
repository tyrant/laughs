class Gig < ApplicationRecord

  has_many :spots
  has_many :comedians, through: :sets
  belongs_to :venue
  

  # What it says on the tin. Returns: the gig object, and a created? boolean.
  def Gig.find_or_create_by(input_gig, venue)

    time = DateTime.parse(input_gig[:date])

    unless gig = Gig.where(venue: venue, time: time).first

      # Doesn't exist. Make it.
      gig = Gig.create({
        venue:                    venue,
        time:                     time,
        venue_booking_url:        input_gig[:venue_booking_url],
        ticketmaster_booking_url: input_gig[:ticketmaster_booking_url]
      })
      created = true

    else
      created = false

    end

    return gig, created
  end


  def as_json(params={})
    {
      id:                       self.id,
      time:                     self.time.to_i,
      venue_booking_url:        self.venue_booking_url,
      ticketmaster_booking_url: self.ticketmaster_booking_url,
      spots:                    self.spots.as_json(gig: 'id', comedian: 'full')
    }
  end

end