class VenuesController < ApplicationController


  def index
    @venues = Rails.cache.fetch([params[:comedians], params[:start_date], params[:end_date]], expires_in: 1.day) do
      Venue.filter(strong_params)
    end

    render json: @venues
  end


  private


  def strong_params
    params.permit({ comedians: [] }, { with: [] }, { without: [] }, :start_date, :end_date, :id, :lat, :lng, :zoom, :ne_lat, :ne_lng, :sw_lat, :sw_lng)
  end

end