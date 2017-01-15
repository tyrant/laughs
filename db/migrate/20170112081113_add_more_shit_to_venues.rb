class AddMoreShitToVenues < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :phone, :string
    add_column :venues, :deets, :string
  end
end
