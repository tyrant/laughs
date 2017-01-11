class CreateCoreTables < ActiveRecord::Migration[5.0]

  def change

    create_table :addresses do |t|
      t.string :readable
      t.float :lat
      t.float :lng
      t.timestamps
    end

    create_table :venues do |t|
      t.string :name
      t.string :description
      t.references :address
      t.timestamps
    end

    create_table :gigs do |t|
      t.timestamp :time
      t.references :venue
      t.timestamps
    end

    create_table :comedians do |t|
      t.string :name
      t.timestamps
    end

    create_table :comedians_gigs, id: false do |t|
      t.references :gigs
      t.references :comedians
    end

  end
end
