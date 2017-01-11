class RrCreateHabtmTableWithCorrectNames < ActiveRecord::Migration[5.0]
  def change
    rename_column :comedians_gigs, :gigs_id, :gig_id
    rename_column :comedians_gigs, :comedians_id, :comedian_id
  end
end
