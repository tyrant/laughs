class Alert < ApplicationRecord

  belongs_to :user
  has_many :comedian_alerts
  has_many :comedians, through: :comedian_alerts

  def as_json(params={})
    {
      id:               self.id,
      user_id:          self.user_id,
      google_place_id:  self.google_place_id,
      city_country:     self.city_country,
      readable_address: self.readable_address,
      comedian_alerts:  self.comedian_alerts.as_json(comedian: 'id', alert: 'id')
    }
  end
end