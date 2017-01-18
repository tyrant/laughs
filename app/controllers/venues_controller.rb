class VenuesController < ApplicationController


  def show
    @venue = Venue.find(permitted_params[:id])
    @gigs = Gig.filter(permitted_params)
  end



  def permitted_params
    params.permit({ comedians: [] }, :start_date, :end_date, :id, :lat, :lng, :zoom)
  end

end