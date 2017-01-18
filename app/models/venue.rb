class Venue < ApplicationRecord

  # AR association shenanigans. Check out http://guides.rubyonrails.org/association_basics.html#the-types-of-associations.
  has_many :gigs


  scope :locatable, -> { where('latitude is not null and longitude is not null') }
  scope :terra_incognita, -> { where('latitude is null and longitude is null') }


  def Venue.filter(params)
    venues = locatable.joins(gigs: :comedians).includes(gigs: :comedians)
    venues = venues.where('comedians.id in (?)', params[:comedians]) unless params[:comedians].blank?
    venues = venues.where('gigs.time > ?', DateTime.parse(params[:start_date])) unless params[:start_date].blank?
    venues = venues.where('gigs.time < ?', DateTime.parse(params[:end_date])) unless params[:end_date].blank?
    venues
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


  # This venue's photos, as provided by Google's Places API.
  def gp_photos
    @photos ||= GP.client.spot(self.google_place_id).photos
  end


  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end


  def as_json(params={})
    {
      id:               self.id,
      name:             self.name,
      to_param:         self.to_param,
      latitude:         self.latitude,
      longitude:        self.longitude,
      readable_address: self.readable_address
    }
  end
end