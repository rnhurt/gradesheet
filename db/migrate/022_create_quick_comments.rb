class CreateQuickComments < ActiveRecord::Migration
  def self.up
    create_table :quick_comments do |t|
      t.string  :description
      t.boolean :active
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :quick_comments
  end
end
