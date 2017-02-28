class VenuesController < ApplicationController


  def index
    render json: Venue.filter(strong_params)
  end


  private


  def strong_params
    params.permit({ comedians: [] }, { with: [] }, { inside: [:ne_lat, :ne_lng, :sw_lat, :sw_lng] }, :start_date, :end_date, :lat, :lng, :zoom)
  end

end