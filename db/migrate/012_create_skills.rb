class CreateSkills < ActiveRecord::Migration
  def self.up
    create_table :skills do |t|
      t.string  :symbol
      t.string  :description
      t.boolean :active
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :skills
  end
end
