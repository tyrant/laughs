class CreateIndexOnVenueLocation < ActiveRecord::Migration[5.0]
  def change
    add_index :venues, :location, using: :gist
  end
end
