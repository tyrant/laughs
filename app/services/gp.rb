# A nice, terse wrapper for the Google Places API.
module GP


  API_KEY = "AIzaSyDs_RUMrFDZVJ4lmbv9ssFUAoWld5lf--4"


  def GP.client
    @client ||= GooglePlaces::Client.new(API_KEY)
  end


  # Let's face it, this is mainly what we use it for
  def GP.spots_by_query(query)
    GP.client.spots_by_query(query)
  end


  # Sometimes we have to deal with a site's truly horrendous place descriptions.
  # Pad that shit out with "Theatre". We like theatres.
  def GP.first_plausible_spot(query)
    spots = GP.spots_by_query(query)

    if spots.length == 0 || spots.length > 1
      @client.spots_by_query("#{query} Theatre").first
    else
      spots.first
    end
  end


  # For REASONS UNKNOWN, #first_plausible_spot doesn't return address details - 
  # you have to hit @client.spot to get those.
  def GP.spot(place_id)
    @client.spot(place_id)
  end
end