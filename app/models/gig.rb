class Gig < ApplicationRecord

  has_and_belongs_to_many :comedians
  belongs_to :venue


  def Gig.filter(params)
    joins(:comedians, :venue).includes(:comedians, :venue)
      .where(venue_id: params[:id])
      .where('comedians.id in (?)', params[:comedians])
      .where('time > ?', DateTime.parse(params[:start_date]))
      .where('time < ?', DateTime.parse(params[:end_date]))
  end
  

  def as_json(params={})
    {
      time:                     self.time,
      venue_booking_url:        self.venue_booking_url,
      ticketmaster_booking_url: self.ticketmaster_booking_url,
      comedians:                self.comedians
    }
  end

end
