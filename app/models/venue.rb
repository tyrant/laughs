class Venue < ApplicationRecord

  # AR association shenanigans. Check out http://guides.rubyonrails.org/association_basics.html#the-types-of-associations.
  has_many :gigs


  validates :latitude, numericality: { greater_than: -90, less_than: 90 }, if: "latitude.present?"
  validates :longitude, numericality: { greater_than: -180, less_than: 180 }, if: "longitude.present?"
 

  scope :locatable, -> { where('latitude is not null and longitude is not null') }
  scope :terra_incognita, -> { where('latitude is null and longitude is null') }


  def Venue.filter(params = {})

    venues = locatable.joins(gigs: { spots: :comedian }).includes(gigs: { spots: :comedian })

    if params[:comedians].present?
      venues = venues.where('comedians.id in (?)', params[:comedians])
    end

    if params[:start_date].present? && params[:end_date].present?
      from = Time.at(params[:start_date].to_i).to_datetime
      to = Time.at(params[:end_date].to_i).to_datetime

      venues = venues.where('gigs.time >= ? and gigs.time <= ?', from, to)  
    end

    if params[:without].present?
      venues = venues.where('venues.id not in (?)', params[:without])
    end

    if params[:sw_lat].present? && params[:ne_lat].present?
      venues = venues.where('venues.latitude > ? and venues.latitude < ?', params[:sw_lat], params[:ne_lat])
    end

    if params[:sw_lng].present? && params[:ne_lng].present?

      # Normal
      if params[:ne_lng] > params[:sw_lng]
        venues = venues.where('venues.longitude > ? and venues.longitude < ?', params[:sw_lng], params[:ne_lng])

      # Straddling date line
      else
        venues = venues.where('venues.longitude > ? or venues.longitude < ?', params[:sw_lng], params[:ne_lng])
      end
    end

    # If any venues IDs are included here, we'd like to also include them 
    # in the result set regardless of whether they meet the above conditions.
    if params[:with].present?
      venues = venues.or(Venue.joins(gigs: { spots: :comedian }).includes(gigs: { spots: :comedian }).where('venues.id in (?)', params[:with]))
    end

    venues
  end


  def Venue.find_or_create_by(gig)

    # We really, really don't want to hit the Places API every single goddamn time
    # we check a venue's uniqueness. Chew up our quota in no time.
    # I know the daily limit is 150,000, but still. Let's be scalable.
    # First, use our scraped 'venue_deets' to query for the venue.

    # Slight problem. Say two or more sites have crappy and differing descriptions 
    # for the same venue. We don't want to create multiple venue objects that turn out
    # to have the same place ID. So if finding an existing venue from venue_deets
    # doesn't work, hit up the Places API, get a place ID, and query for that.
    unless venue = Venue.where(deets: gig[:venue_deets]).first

      # No luck! Hit up the Places API. If GP returns no results, or throws a
      # query limit exception, we still want the venue saved. 
      begin
        place = GP.first_plausible_spot(gig[:venue_deets])
      rescue Exception => e
        place = nil
      end

      # If we get a place result, query for a venue in our database based on place ID.
      if place.present? and venue = Venue.find_by_google_place_id(place.place_id) 
        created = false

      else
        # No result there either, eh? Fine. Create the frickin' thing. 
        venue = Venue.create({
          name:             place.present? ? place.name : nil,        
          readable_address: place.present? ? place.formatted_address : nil,
          latitude:         place.present? ? place.lat : nil,
          longitude:        place.present? ? place.lng : nil,
          google_place_id:  place.present? ? place.place_id : nil,
          phone:            gig[:phone],
          deets:            gig[:venue_deets]
        })
        created = true

      end

    else 
      created = false
    end

    return venue, created
  end


  # Often we hit up against the Places API's rate limit. This goes over 
  # the venues not yet placefied, and does so.
  def Venue.placeify 
    Venue.terra_incognita.each do |venue|
      begin
        place = GP.first_plausible_spot(venue.deets)

        if place.present?
          venue.latitude = place.lat
          venue.longitude = place.lng
          venue.readable_address = place.formatted_address
          venue.google_place_id = place.place_id
          venue.name = place.name
          venue.save
        end
      rescue Exception => e
        ap e.message
      end
    end
  end


  def as_json(params={})
    {
      id:               self.id,
      name:             self.name,
      latitude:         self.latitude,
      longitude:        self.longitude,
      readable_address: self.readable_address,
      phone:            self.phone,
      gigs:             self.gigs.as_json(params)
    }
  end
end