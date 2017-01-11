class Venue < ApplicationRecord

  # AR association shenanigans. Check out http://guides.rubyonrails.org/association_basics.html#the-types-of-associations.
  has_many :gigs

  # Google Places gem shenanigans. Check out https://github.com/qpowell/google_places#retrieving-spots-based-on-query
  after_validation :do_place_fiddly_stuff

  scope :locatable, -> { where('latitude is not null and longitude is not null') }
  scope :terra_incognita, -> { where('latitude is null and longitude is null') }

  # Whenever we save a venue, get its latest from the Google Places API,
  # specifically its latitude and longitude, and get 
  def do_place_fiddly_stuff
    client = GooglePlaces::Client.new(GooglePlaces::API_KEY)
    place = client.spots_by_query(self.readable_address).first

    # Once in a blue moon, not even the mighty Google Places API can extract an actual location
    # from the shit these web monkeys have as place names.
    if place
      self.latitude = place.lat
      self.longitude = place.lng
      self.readable_address = place.formatted_address
    end
  end

  # Future params: latitude/longitude bounds; gig time bounds.
  def as_json(params={})
    {
      name:             self.name,
      latitude:         self.latitude,
      longitude:        self.longitude,
      readable_address: self.readable_address,
      gigs:             self.gigs(params[:gig])
    }
  end
end