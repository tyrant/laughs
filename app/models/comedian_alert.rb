class ComedianAlert < ApplicationRecord

  belongs_to :comedian
  belongs_to :alert


  def as_json(params={})

    # comedian = if params[:comedian] == 'full'
    #   self.comedian.as_json(params)
    # elsif params[:comedian] == 'id'
    #   { id: self.comedian.id }
      
    # end

    # alert = if params[:alert] == 'full'
    #   self.alert.as_json(params)
    # elsif params[:alert] == 'id'
    #   { id: self.alert.id }
    # end

    {
      id:          self.id,
      comedian_id: self.comedian.id,
      alert_id:    self.alert.id
    }
  end
  
end