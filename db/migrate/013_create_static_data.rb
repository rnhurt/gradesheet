class CreateStaticData < ActiveRecord::Migration
  def self.up
    create_table :staticdata do |t|
      t.string  :name
      t.string  :value

      t.timestamps
    end
  end

  def self.down
    drop_table :staticdata
  end
end
