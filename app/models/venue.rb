class Venue < ApplicationRecord

  # AR association shenanigans. Check out http://guides.rubyonrails.org/association_basics.html#the-types-of-associations.
  has_many :gigs


  # Just here so we can set factories
  attr_accessor :latitude
  attr_accessor :longitude

  def Venue.inside(ne_lat, ne_lng, sw_lat, sw_lng)

    factory = RGeo::Geographic.spherical_factory(srid: 4326)
    box = factory.linear_ring([
      factory.point(sw_lng, sw_lat),
      factory.point(sw_lng, ne_lat),
      factory.point(ne_lng, ne_lat),
      factory.point(ne_lng, sw_lat),
      factory.point(sw_lng, sw_lat),
    ])
    polygon = factory.polygon(box)

    where('venues.location && ?', polygon)
  end


  def Venue.filter(params = {})

    # Beautiful, isn't it? If we do a simple AR joins(),
    # that's an inner join, and venues without gigs don't get returned.
    join_condition = 'full join gigs on venues.id=gigs.venue_id full join spots on gigs.id=spots.gig_id full join comedians on spots.comedian_id=comedians.id'

    venues = joins(join_condition).distinct.includes(gigs: { spots: :comedian })

    # Grab all venues being played by these comedians.
    venues = venues.where('comedians.id in (?)', params[:comedians]) if params[:comedians].present?

    # Grab all venues with their gigs within these date bounds.
    if params[:start_date].present? && params[:end_date].present?
      from = Time.at(params[:start_date].to_i).to_datetime
      to = Time.at(params[:end_date].to_i).to_datetime

      venues = venues.where('gigs.time >= ? and gigs.time <= ?', from, to)  
    end

    # If any venues IDs are included here, we'd like to also include them 
    # in the result set regardless of whether they meet the above conditions.
    if params[:with].present?
      with = Venue.joins(join_condition)
        .distinct
        .includes(gigs: { spots: :comedian })
        .where('venues.id in (?)', params[:with])

      venues = venues.or(with)
    end

    after_with = Time.now.to_f

    # An 'inside' box? Fence those venues in.
    if params[:inside].present? && params[:zoom].present?

      # Kick shit off.
      before_cell = Time.now.to_f
      venues = venues.inside(params[:inside][:ne_lat], params[:inside][:ne_lng], params[:inside][:sw_lat], params[:inside][:sw_lng])
      after_cell = Time.now.to_f

      cell_pixel_width = 70
      zoom = params[:zoom].to_i
      
      ne_x, ne_y = Projection.latlng_to_pixels params[:inside][:ne_lat], params[:inside][:ne_lng], params[:zoom]
      sw_x, sw_y = Projection.latlng_to_pixels params[:inside][:sw_lat], params[:inside][:sw_lng], params[:zoom]

      # Dateline straddling? Bump up ne_x.
      ne_x += ((2 ** zoom) * Projection::TILE_SIZE) if ne_x < sw_x

      # Get the user's screen dimensions.
      screen_x = (ne_x - sw_x).to_i
      screen_y = (ne_y - sw_y).to_i

      # Move our top-right marker to be a multiple of cell_pixel_width, so that if we
      # render our markers once, then move the map, the markers and clusters appear in
      # the same geographical location.
      ne_x = ne_x.to_i + cell_pixel_width - (ne_x.to_i % cell_pixel_width)
      ne_y = ne_y.to_i + cell_pixel_width - (ne_y.to_i % cell_pixel_width)

      query = lambda {

        markers = {
          groups: [],
          venues: []
        }

        # Now we do a O(n^2) loop over our cells. Get the number of cells for lat and lng.
        x_cell_count = screen_x / cell_pixel_width
        y_cell_count = screen_y / cell_pixel_width

        # Add 2 to be sure we overlap the user's screen.
        (x_cell_count + 2).times do |i|
          (y_cell_count + 2).times do |j|

            # Get lat/lng of each individual cell.
            i_ne_px = ne_x - (i * cell_pixel_width)
            j_ne_px = ne_y - (j * cell_pixel_width)

            cell_ne_lat, cell_ne_lng = Projection.pixels_to_latlng i_ne_px, j_ne_px, zoom

            i_sw_px = ne_x - ((i+1) * cell_pixel_width)
            j_sw_px = ne_y - ((j+1) * cell_pixel_width)

            cell_sw_lat, cell_sw_lng = Projection.pixels_to_latlng i_sw_px, j_sw_px, zoom

            cell_key = "#{cell_ne_lat} #{cell_ne_lng} #{cell_sw_lat} #{cell_sw_lng} #{zoom}"

            cell_venues = Rails.cache.fetch(cell_key, expires_in: 1.day) do
              venues.find_all do |venue|
                inside_lat = cell_sw_lat < venue.location.y && venue.location.y < cell_ne_lat
                inside_lng = cell_sw_lng < venue.location.x && venue.location.x < cell_ne_lng
                inside_lat && inside_lng
              end.map{|v| v.as_json }
              #venues.inside(cell_ne_lat, cell_ne_lng, cell_sw_lat, cell_sw_lng)
            end

            # Great. Now get the number of locations inside this cell.
            cell_count = cell_venues.count

            # More than three? And zoom is <16? Get the center.
            if cell_count > 3 && zoom < 16

              cell_centre_lat = (cell_sw_lat + cell_ne_lat)/2

              # Again with the dateline straddling!
              cell_ne_lng += 360 if cell_ne_lng < cell_sw_lng
              cell_centre_lng = (cell_sw_lng + cell_ne_lng)/2

              # Normally we'd do gigs.count, but that does a separate 'select count(*)' query
              # for every single cell. Takes ages. With gigs.length, we can execute everything
              # in Venue.filter in just four queries.
              # And! Let's randomise each lat/lng by +/-.075 degrees, to make things less sterile.
              markers[:groups] << {
                latitude:  cell_centre_lat + (SecureRandom.random_number * 0.15)-0.075,
                longitude: cell_centre_lng + (SecureRandom.random_number * 0.15)-0.075,
                type:      'group',
                ids:       cell_venues.map{|v| v[:id] },
                gig_count: cell_venues.map{|v| v[:gigs].length }.sum 
              }

            # Otherwise, if we have 1-3 venues here, just grab their info directly.
            elsif cell_count > 0
              markers[:venues].concat cell_venues
            end
          end
        end

        markers
      }

      # For caching purposes. They've already been jinked to the nearest cell boundary, see.
      ne_lat, ne_lng = Projection.pixels_to_latlng ne_x, ne_y, zoom
      sw_lat, sw_lng = Projection.pixels_to_latlng sw_x, sw_y, zoom

      before_call = Time.now.to_f
      total_key = "#{ne_lat} #{ne_lng} #{sw_lat} #{sw_lng} #{zoom}"
      ap "total key: #{total_key}"

      markers = Rails.cache.fetch(total_key, expires_in: 1.day) do
        query.call
      end
      after_call = Time.now.to_f

    end

    after_inside = Time.now.to_f

    ap "After inside: #{after_inside - after_with}"

    markers
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
        venue = Venue.new({
          name:             place.present? ? place.name : nil,        
          readable_address: place.present? ? place.formatted_address : nil,
          google_place_id:  place.present? ? place.place_id : nil,
          phone:            gig[:phone],
          deets:            gig[:venue_deets]
        })
        venue.set_location({
          latitude:  place.present? ? place.lat : nil,
          longitude: place.present? ? place.lng : nil,
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
          venue.set_location(latitude: place.lat, longitude: place.lng)
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


  # Ye gods setting this took a long time to discover. Check out 
  # github.com/rgeo/activerecord-postgis-adapter/issues/190.
  # Note the order: longitude, *then* latitude.
  def set_location(params={})
    @factory ||= RGeo::ActiveRecord::SpatialFactoryStore.instance.factory(geo_type: 'point')
    self.location = @factory.point(params[:longitude], params[:latitude])
  end


  def as_json(params={})
    {
      id:               self.id,
      name:             self.name,
      latitude:         self.location.y,
      longitude:        self.location.x,
      readable_address: self.readable_address,
      phone:            self.phone,
      gigs:             self.gigs.as_json(params)
    }
  end
end