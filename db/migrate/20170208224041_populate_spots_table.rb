class PopulateSpotsTable < ActiveRecord::Migration[5.0]


  def up

    ActiveRecord::Base.connection.execute('select * from comedians_gigs').each do |row|
      Spot.create(gig_id: row[:gig_id], comedian_id: row[:comedian_id])
    end

    #drop_table :comedians_gigs
  end


  def down

    create_table :comedians_gigs, id: false do |t|
      t.references :gig
      t.references :comedian
    end

    Spot.find_each do |set|
      ActiveRecord::Base.connection.execute("insert into comedians_gigs (comedian_id, gig_id) values('#{set.comedian_id}', '#{set.gig_id}')")
    end
  end
end
