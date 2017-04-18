class CreateAlerts < ActiveRecord::Migration[5.0]

  def change
    create_table :alerts do |t|
      t.references :user
      t.string :google_place_id
      t.string :warning
    end
  end
end
