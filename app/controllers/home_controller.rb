class HomeController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.js { @venues = Venue.filter(permitted_params) }
    end
  end


  def permitted_params
    params.permit({ comedians: [] }, :start_date, :end_date, :lat, :lng, :zoom)
  end

end
