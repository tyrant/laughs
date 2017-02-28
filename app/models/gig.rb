class Gig < ApplicationRecord

  has_many :spots
  has_many :comedians, through: :spots
  belongs_to :venue
  

  # What it says on the tin. 
  # @param input_gig. A hash of readable datetime, venue_booking_url and ticketmaster_booking_url.
  # @param venue. AR object.
  # @param comedian. AR object.
  # Returns: the gig object, and a created? boolean.
  def Gig.find_or_create_by(params={})

    # Teensy problem. input_gig[:date] is any date string the website might have -
    # "7 Jul 2018", that kind of thing. DateTime.parse defaults its zone to UTC.

    datetime = DateTime.parse(params[:input_gig][:date]) # DateTime.parse defaults to UTC!

    if !!params[:venue].latitude && !!params[:venue].longitude

      # Problem! The Google timezone API returns zero results over ocean. 
      # In practice this ain't a problem, as it's unlikely we'll have gigs on
      # cruise ships, but getting our test factories to spit out only land
      # (lat, lng) is not easy. Catch exceptions instead.
      begin
        timezone = Timezone.lookup(params[:venue].latitude, params[:venue].longitude) # Venue time zone!
        timezoned_datetime = timezone.utc_to_local(datetime)

      rescue Exception => e
        timezoned_datetime = datetime

      end

    else 
      timezoned_datetime = datetime 

    end

    # Next. Uniquely identifying a gig is tricky. Some comedian websites
    # have specific dates *and* times for a gig; others just have dates. 
    # Let's assume that if a comedian's gig's datetime has no time info, then 
    # they won't have another gig at that venue on that day.

    # First, get a list of all gigs at our venue and attended by our comedian.
    gig = Gig.joins(spots: :comedian)
      .where(venue: params[:venue])
      .where('comedians.id = ?', params[:comedian].id)

    # No time info on our input date string? Match to the nearest +/- waffle_bounds.
    gig = if datetime.hour == 0 && datetime.minute == 0 && datetime.second == 0
      waffle_bounds = 12.hours
      gig.where(time: (timezoned_datetime - waffle_bounds)..(timezoned_datetime + waffle_bounds))

    # Otherwise, use an exact match
    else
      gig.where(time: timezoned_datetime)

    end.first

    unless gig

      # Doesn't exist. Make it.
      gig = Gig.create({
        venue:                    params[:venue],
        time:                     timezoned_datetime,
        venue_booking_url:        params[:input_gig][:venue_booking_url],
        ticketmaster_booking_url: params[:input_gig][:ticketmaster_booking_url]
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