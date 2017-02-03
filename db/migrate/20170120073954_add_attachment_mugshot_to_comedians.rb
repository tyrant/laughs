class AddAttachmentMugshotToComedians < ActiveRecord::Migration[5.0]
  def self.up
    change_table :comedians do |t|
      t.attachment :mugshot
    end
  end

  def self.down
    remove_attachment :comedians, :mugshot
  end
end
