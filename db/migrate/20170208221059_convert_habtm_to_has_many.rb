class ConvertHabtmToHasMany < ActiveRecord::Migration[5.0]

  def up
    # Create a 'spots' table, mapping a comedian to a gig.
    create_table :spots do |t|
      t.references :gig
      t.references :comedian
      t.timestamps
    end

    add_index :spots, [:gig_id, :comedian_id]
  end

  def down
    drop_table :spots
  end
end
