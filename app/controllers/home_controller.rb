class HomeController < ApplicationController

  def index
    respond_to do |format|
      format.html
      format.js { @venues = filter(permitted_params) }
    end
  end


  def filter(params)
    venues = Venue.locatable.joins(gigs: :comedians).includes(gigs: :comedians)
    venues = venues.where('comedians.id IN (?)', params[:comedians]) unless params[:comedians].blank?
    venues = venues.where('gigs.time > ?', params[:start_date]) unless params[:start_date].blank?
    venues = venues.where('gigs.time < ?', params[:end_date]) unless params[:end_date].blank?
    venues
  end


  def permitted_params
    params.permit({comedians: []}, :start_date, :end_date)
  end

end
