class VenuesController < ApplicationController


  def index
    @venues = Rails.cache.fetch([params[:comedians], params[:start_date], params[:end_date]], expires_in: 1.day) do
      Venue.filter(strong_params)
    end

    render json: @venues
  end


  def show
    @venue = Venue.find(strong_params[:id])
    @gigs = Gig.filter(strong_params)
  end


  private


  def strong_params
    params.permit({ comedians: [] }, { without: [] }, :start_date, :end_date, :id, :lat, :lng, :zoom)
  end

end