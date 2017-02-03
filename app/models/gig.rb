class Gig < ApplicationRecord

  has_and_belongs_to_many :comedians
  belongs_to :venue


  def Gig.filter(params)
    gigs = joins(:comedians, :venue).includes(:comedians, :venue).where(venue_id: params[:id])
    gigs = gigs.where('comedians.id in (?)', params[:comedians]) unless params[:comedians].blank?
    gigs = gigs.where('time > ?', Time.at(params[:start_date].to_i).to_datetime) unless params[:start_date].blank?
    gigs = gigs.where('time < ?', Time.at(params[:end_date].to_i).to_datetime) unless params[:end_date].blank?
  end
  

  def as_json(params={})
    {
      id:                       self.id,
      time:                     self.time.to_i,
      venue_booking_url:        self.venue_booking_url,
      ticketmaster_booking_url: self.ticketmaster_booking_url,
      comedians:                self.comedians
    }
  end

end
