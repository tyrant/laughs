# A spot is an object joining gigs and comedians. It allows both for 
# double acts performing together, and for multiple comedians at the same
# event.

class Spot < ApplicationRecord

  belongs_to :gig
  belongs_to :comedian

  validates :gig, presence: true
  validates :comedian, presence: true

  def Spot.find_or_create_by(comedian, gig)

    unless spot = Spot.where(comedian: comedian, gig: gig).first

      spot = Spot.create({
        gig:      gig,
        comedian: comedian
      })
      created = true

    else
      created = false

    end

    return spot, created
  end


  # For both gig and comedian, pass in either 'full' or 'id'.
  def as_json(params={})

    gig = if params[:gig] == 'full'
      self.gig.as_json(params)
    elsif params[:gig] == 'id'
      { id: self.gig.id }
    end

    comedian = if params[:comedian] == 'full'
      self.comedian.as_json(params)
    elsif params[:comedian] == 'id'
      { id: self.comedian.id }
    end

    {
      id:       self.id,
      gig:      gig,
      comedian: comedian
    }
  end

end