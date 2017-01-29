class Gig < ApplicationRecord

  has_and_belongs_to_many :comedians
  belongs_to :venue


  def Gig.filter(params)
    gigs = joins(:comedians, :venue).includes(:comedians, :venue).where(venue_id: params[:id])
    gigs = gigs.where('comedians.id in (?)', params[:comedians]) unless params[:comedians].blank?
    gigs = gigs.where('time > ?', DateTime.parse(params[:start_date])) unless params[:start_date].blank?
    gigs = gigs.where('time < ?', DateTime.parse(params[:end_date])) unless params[:end_date].blank?
  end
  

  def as_json(params={})
    {
      id:                       self.id,
      time:                     self.time,
      venue_booking_url:        self.venue_booking_url,
      ticketmaster_booking_url: self.ticketmaster_booking_url,
      comedians:                self.comedians
    }
  end

end
