class AddCityCountryAndReadableAddressToAlerts < ActiveRecord::Migration[5.0]
  def change
    add_column :alerts, :city_country, :string
    add_column :alerts, :readable_address, :string
  end
end
