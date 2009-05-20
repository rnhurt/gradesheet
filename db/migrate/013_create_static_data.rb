class CreateStaticData < ActiveRecord::Migration
  def self.up
    create_table :static_data do |t|
      t.string  :name
      t.string  :value

      t.timestamps
    end
  end

  def self.down
    drop_table :static_data
  end
end
