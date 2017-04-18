class AddComedianAlert < ActiveRecord::Migration[5.0]
  def change
    create_table :comedian_alerts do |t|
      t.references :comedian
      t.references :alert
      t.timestamps
    end
  end
end
