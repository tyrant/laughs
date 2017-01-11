class RemoveAddressIdFromVenue < ActiveRecord::Migration[5.0]
  def change
    remove_column :venues, :address_id
  end
end
